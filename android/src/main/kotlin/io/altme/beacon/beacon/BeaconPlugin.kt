package io.altme.beacon.beacon

import android.util.Log
import com.google.gson.Gson
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import it.airgap.beaconsdk.blockchain.substrate.data.SubstrateAccount
import it.airgap.beaconsdk.blockchain.substrate.data.SubstrateNetwork
import it.airgap.beaconsdk.blockchain.substrate.message.request.PermissionSubstrateRequest
import it.airgap.beaconsdk.blockchain.substrate.message.response.PermissionSubstrateResponse
import it.airgap.beaconsdk.blockchain.substrate.substrate
import it.airgap.beaconsdk.blockchain.tezos.data.TezosAccount
import it.airgap.beaconsdk.blockchain.tezos.data.TezosError
import it.airgap.beaconsdk.blockchain.tezos.data.TezosNetwork
import it.airgap.beaconsdk.blockchain.tezos.data.TezosPermission
import it.airgap.beaconsdk.blockchain.tezos.data.operation.*
import it.airgap.beaconsdk.blockchain.tezos.extension.from
import it.airgap.beaconsdk.blockchain.tezos.message.request.BroadcastTezosRequest
import it.airgap.beaconsdk.blockchain.tezos.message.request.OperationTezosRequest
import it.airgap.beaconsdk.blockchain.tezos.message.request.PermissionTezosRequest
import it.airgap.beaconsdk.blockchain.tezos.message.request.SignPayloadTezosRequest
import it.airgap.beaconsdk.blockchain.tezos.message.response.BroadcastTezosResponse
import it.airgap.beaconsdk.blockchain.tezos.message.response.OperationTezosResponse
import it.airgap.beaconsdk.blockchain.tezos.message.response.PermissionTezosResponse
import it.airgap.beaconsdk.blockchain.tezos.message.response.SignPayloadTezosResponse
import it.airgap.beaconsdk.blockchain.tezos.tezos
import it.airgap.beaconsdk.client.wallet.BeaconWalletClient
import it.airgap.beaconsdk.client.wallet.compat.stop
import it.airgap.beaconsdk.core.client.BeaconClient
import it.airgap.beaconsdk.core.data.BeaconError
import it.airgap.beaconsdk.core.data.P2pPeer
import it.airgap.beaconsdk.core.message.BeaconMessage
import it.airgap.beaconsdk.core.message.BeaconRequest
import it.airgap.beaconsdk.core.message.ErrorBeaconResponse
import it.airgap.beaconsdk.core.data.Peer
import it.airgap.beaconsdk.core.data.SigningType
import it.airgap.beaconsdk.core.internal.data.HexString
import it.airgap.beaconsdk.transport.p2p.matrix.p2pMatrix
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.ArrayList
import java.util.HashMap

/** BeaconPlugin */
class BeaconPlugin : MethodChannel.MethodCallHandler, EventChannel.StreamHandler, FlutterPlugin {
    private val tag = "BeaconPlugin"

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "beaconMethod")
        methodChannel.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "beaconEvent")
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "startBeacon" -> {
                startBeacon(result)
            }
            "tezosResponse" ->
                tezosResponse(call, result)
            "respondExample" ->
                respondExample(result)
            "pair" -> {
                val pairingRequest: String = call.argument("pairingRequest") ?: ""
                pair(pairingRequest, result)
            }
            "addPeer" -> {
                val id: String = call.argument("id") ?: ""
                val name: String = call.argument("name") ?: ""
                val publicKey: String = call.argument("publicKey") ?: ""
                val relayServer: String = call.argument("relayServer") ?: ""
                val version: String = call.argument("version") ?: ""
                addPeer(id, name, publicKey, relayServer, version, result)
            }
            "removePeers" -> {
                removePeers(result)
            }
            "removePeer" -> {
                val publicKey: String = call.argument("publicKey") ?: ""
                removePeer(publicKey, result)
            }
            "getPeers" -> {
                getPeers(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        CoroutineScope(Dispatchers.IO).launch {
            publisher
                .collect { request ->
                    withContext(Dispatchers.Main) {
                        val map: HashMap<String, Any> = HashMap()

                        map["request"] = request

                        when (request) {
                            is PermissionTezosRequest -> {
                                map["type"] = "permission"

                                val peerPublicKey = request.origin.id

                                val peers =
                                    beaconClient?.getPeers();
                                val peer = peers!!.first { peer -> peer.publicKey == peerPublicKey }
                                map["peer"] = peer
                            }
                            is SignPayloadTezosRequest -> {
                                map["type"] = "signPayload"
                            }
                            is OperationTezosRequest -> {
                                val operationRequest: OperationTezosRequest = request

                                map["type"] = "operation"

                                fun getParams(value: MichelineMichelsonV1Expression): Any {
                                    val result: HashMap<String, Any> = HashMap()

                                    when (value) {
                                        is MichelinePrimitiveApplication -> {
                                            result["prim"] = value.prim
                                            value.args?.map { arg -> getParams(arg) }?.let {
                                                result["args"] = it
                                            }
                                            value.annots?.let {
                                                result["annots"] = it
                                            }
                                        }
                                        is MichelinePrimitiveInt -> {
                                            result["int"] = value.int
                                        }
                                        is MichelinePrimitiveString -> {
                                            result["string"] = value.string
                                        }
                                        is MichelinePrimitiveBytes -> {
                                            result["bytes"] =
                                                HexString(value.bytes).asString(withPrefix = false)
                                        }
                                        is MichelineNode -> {
                                            return value.expressions.map { arg -> getParams(arg) }
                                        }
                                    }

                                    return result
                                }

                                val operationDetails: ArrayList<HashMap<String, Any>> = ArrayList()
                                operationRequest.operationDetails.forEach { operation ->
                                    if (operation.kind == TezosOperation.Kind.Origination) {
                                        (operation as? TezosOriginationOperation)?.let { origination ->
                                            val detail: HashMap<String, Any> = HashMap()
                                            detail["kind"] = "origination"
                                            origination.source?.let {
                                                detail["source"] = it
                                            }
                                            origination.gasLimit?.let {
                                                detail["gasLimit"] = it
                                            }
                                            origination.storageLimit?.let {
                                                detail["storageLimit"] = it
                                            }
                                            origination.fee?.let {
                                                detail["fee"] = it
                                            }
                                            origination.balance.let {
                                                detail["amount"] = it
                                            }
                                            origination.counter?.let {
                                                detail["counter"] = it
                                            }
                                            detail["code"] = getParams(origination.script.code)
                                            detail["storage"] =
                                                getParams(origination.script.storage)

                                            operationDetails.add(detail)
                                        }
                                    } else {
                                        (operation as? TezosTransactionOperation)?.let { transaction ->
                                            val detail: HashMap<String, Any> = HashMap()
                                            detail["kind"] = "transaction"
                                            transaction.destination.let {
                                                detail["destination"] = it
                                            }
                                            transaction.source?.let {
                                                detail["source"] = it
                                            }
                                            transaction.gasLimit?.let {
                                                detail["gasLimit"] = it
                                            }
                                            transaction.storageLimit?.let {
                                                detail["storageLimit"] = it
                                            }
                                            transaction.fee?.let {
                                                detail["fee"] = it
                                            }
                                            transaction.amount.let {
                                                detail["amount"] = it
                                            }
                                            transaction.counter?.let {
                                                detail["counter"] = it
                                            }
                                            transaction.parameters?.entrypoint?.let {
                                                detail["entrypoint"] = it
                                            }
                                            transaction.parameters?.value?.let { value ->
                                                getParams(
                                                    value
                                                )
                                            }
                                                ?.let {
                                                    detail["parameters"] = it
                                                }

                                            operationDetails.add(detail)
                                        }
                                    }
                                }

                                map["operationDetails"] = operationDetails
                            }
                            is BroadcastTezosRequest -> {
                                map["type"] = "broadcast"
                            }
                            else -> {}
                        }
                        events?.success(Gson().toJson(map))
                    }
                }
        }
    }

    override fun onCancel(arguments: Any?) {}


    private var beaconClient: BeaconWalletClient? = null
    private var awaitingRequest: BeaconRequest? = null


    private var publisher = MutableSharedFlow<BeaconRequest>()

    private fun startBeacon(result: Result) {
        CoroutineScope(Dispatchers.IO).launch {
            beaconClient = BeaconWalletClient("Altme") {
                support(tezos(), substrate())
                use(p2pMatrix())

                ignoreUnsupportedBlockchains = true
            }


            val peers = beaconClient?.getPeers()
            val hasPeer = peers?.isNotEmpty() ?: false
            result.success(mapOf("success" to hasPeer))

            launch {
                beaconClient?.connect()
                    ?.onEach { result -> result.getOrNull()?.let { saveAwaitingRequest(it) } }
                    ?.collect { result ->
                        result.getOrNull()?.let {
                            publisher.emit(it)
                        }
                    }
            }
        }
    }

    private fun tezosResponse(call: MethodCall, result: Result) {
        val id: String? = call.argument("id")
        val request = awaitingRequest ?: return

        if (request.id != id) return

        CoroutineScope(Dispatchers.IO).launch {
            val response = when (request) {
                is PermissionTezosRequest -> {
                    val publicKey: String? = call.argument("publicKey")
                    val address: String? = call.argument("address")

                    publicKey?.let {
                        PermissionTezosResponse.from(
                            request,
                            TezosAccount(
                                it,
                                address!!,
                                request.network,
                                beaconClient!!
                            ),
                            listOf(
                                TezosPermission.Scope.Sign,
                                TezosPermission.Scope.OperationRequest
                            )
                        )
                    } ?: ErrorBeaconResponse.from(request, BeaconError.Aborted)
                }
                is OperationTezosRequest -> {
                    val transactionHash: String? = call.argument("transactionHash")

                    transactionHash?.let {
                        OperationTezosResponse.from(request, transactionHash)
                    } ?: ErrorBeaconResponse.from(request, BeaconError.Aborted)
                }
                is SignPayloadTezosRequest -> {
                    val signature: String? = call.argument("signature")

                    signature?.let {
                        SignPayloadTezosResponse.from(request, SigningType.Raw, it)
                    } ?: ErrorBeaconResponse.from(request, BeaconError.Aborted)
                }
                is BroadcastTezosRequest -> {
                    val transactionHash: String? = call.argument("transactionHash")

                    transactionHash?.let {
                        BroadcastTezosResponse.from(request, transactionHash)
                    } ?: ErrorBeaconResponse.from(request, BeaconError.Aborted)
                }
                else -> ErrorBeaconResponse.from(request, BeaconError.Unknown)
            }
            beaconClient?.respond(response)
            removeAwaitingRequest()
            result.success(mapOf("success" to true))
        }
    }

    private fun respondExample(result: Result) {
        val request = awaitingRequest ?: return
        val beaconClient = beaconClient ?: return

        Log.i(tag, request.toString())

        CoroutineScope(Dispatchers.IO).launch {

            val peers = beaconClient.getPeers()
            if (peers.isEmpty()) return@launch

            val response = when (request) {
                /* Tezos */

                is PermissionTezosRequest -> PermissionTezosResponse.from(
                    request,
                    exampleTezosAccount(request.network, beaconClient)
                )
                is OperationTezosRequest -> ErrorBeaconResponse.from(request, BeaconError.Aborted)
                is SignPayloadTezosRequest -> ErrorBeaconResponse.from(
                    request,
                    TezosError.SignatureTypeNotSupported
                )
                is BroadcastTezosRequest -> ErrorBeaconResponse.from(
                    request,
                    TezosError.BroadcastError
                )

                /* Substrate*/

                is PermissionSubstrateRequest -> PermissionSubstrateResponse.from(
                    request,
                    listOf(exampleSubstrateAccount(request.networks.first(), beaconClient))
                )

                /* Others */
                else -> ErrorBeaconResponse.from(request, BeaconError.Unknown)
            }
            beaconClient.respond(response)
            removeAwaitingRequest()
            result.success(mapOf("success" to true))
        }
    }

    private fun pair(pairingRequest: String, result: Result) {
        CoroutineScope(Dispatchers.IO).launch {
            beaconClient?.pair(pairingRequest)
            val peers = beaconClient?.getPeers()
            val hasPeer = peers?.isNotEmpty() ?: false
            result.success(mapOf("success" to hasPeer))
        }
    }

    private fun addPeer(
        id: String,
        name: String,
        publicKey: String,
        relayServer: String,
        version: String,
        result: Result
    ) {
        val peer = P2pPeer(
            id = id,
            name = name,
            publicKey = publicKey,
            relayServer = relayServer,
            version = version,
        )
        CoroutineScope(Dispatchers.IO).launch {
            beaconClient?.addPeers(peer)

            val map: HashMap<String, Any> = HashMap()
            map["success"] = true
            map["result"] = peer

            result.success(Gson().toJson(map))
        }
    }


    private fun removePeers(result: Result) {
        CoroutineScope(Dispatchers.IO).launch {
            beaconClient?.removeAllPeers()
            val peers = beaconClient?.getPeers()
            val hasPeer = peers?.isNotEmpty() ?: false
            result.success(mapOf("success" to !hasPeer))
        }
    }


    private fun removePeer(publicKey: String, result: Result) {
        CoroutineScope(Dispatchers.IO).launch {
            val peers = beaconClient?.getPeers()
            val hasPeer = peers?.isNotEmpty() ?: false
            if (hasPeer) {
                val peer: List<Peer> = peers!!.filter { it.publicKey == publicKey }
                beaconClient?.removePeers(peer)
                result.success(mapOf("success" to true))
            } else {
                result.success(mapOf("success" to false))
            }
        }
    }


    private fun getPeers(result: Result) {
        CoroutineScope(Dispatchers.IO).launch {
            val peers = beaconClient?.getPeers()

            val map: HashMap<String, Any> = HashMap()
            map["success"] = true
            map["peer"] = peers!!

            val response = Gson().toJson(map)
            result.success(response)
        }
    }


    private fun saveAwaitingRequest(message: BeaconMessage) {
        awaitingRequest = if (message is BeaconRequest) message else null
    }

    private fun removeAwaitingRequest() {
        awaitingRequest = null
    }

    companion object {
        fun exampleTezosAccount(network: TezosNetwork, client: BeaconClient<*>): TezosAccount =
            TezosAccount(
                "edpktpzo8UZieYaJZgCHP6M6hKHPdWBSNqxvmEt6dwWRgxDh1EAFw9",
                "tz1Mg6uXUhJzuCh4dH2mdBdYBuaiVZCCZsak",
                network,
                client,
            )

        fun exampleSubstrateAccount(
            network: SubstrateNetwork,
            client: BeaconClient<*>
        ): SubstrateAccount = SubstrateAccount(
            "724867a19e4a9422ac85f3b9a7c4bf5ccf12c2df60d858b216b81329df716535",
            "13aqy7vzMjuS2Nd6TYahHHetGt7dTgaqijT6Tpw3NS2MDFug",
            network,
            client,
        )
    }
}