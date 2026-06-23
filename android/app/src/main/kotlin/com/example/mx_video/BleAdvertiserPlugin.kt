package com.example.mx_video

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.BluetoothLeAdvertiser
import android.content.Context
import android.os.ParcelUuid
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.nio.ByteBuffer
import java.util.UUID

/**
 * Native Android plugin for BLE peripheral advertising.
 *
 * Allows the app to advertise itself as an MX Video device via BLE
 * so that iOS/other devices can discover it even without shared WiFi.
 */
class BleAdvertiserPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private var channel: MethodChannel? = null
    private var context: Context? = null
    private var advertiser: BluetoothLeAdvertiser? = null
    private var advertiseCallback: AdvertiseCallback? = null

    companion object {
        val SERVICE_UUID: UUID = UUID.fromString("a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d")
        const val MANUFACTURER_ID = 0x4D58 // "MX"
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "mx_video/ble_advertiser")
        channel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        stopAdvertising()
        channel?.setMethodCallHandler(null)
        channel = null
        context = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startAdvertising" -> {
                val name = call.argument<String>("name") ?: ""
                val ip = call.argument<String>("ip") ?: "0.0.0.0"
                val port = call.argument<Int>("port") ?: 0
                startAdvertising(name, ip, port, result)
            }
            "stopAdvertising" -> {
                stopAdvertising()
                result.success(null)
            }
            "isAvailable" -> {
                val manager = context?.getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager
                val adapter = manager?.adapter
                val available = adapter?.isEnabled == true && adapter.bluetoothLeAdvertiser != null
                result.success(available)
            }
            else -> result.notImplemented()
        }
    }

    private fun startAdvertising(name: String, ip: String, port: Int, result: MethodChannel.Result) {
        val manager = context?.getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager
        val adapter = manager?.adapter
        if (adapter == null || !adapter.isEnabled) {
            result.error("BLE_UNAVAILABLE", "Bluetooth is not available or not enabled", null)
            return
        }

        advertiser = adapter.bluetoothLeAdvertiser
        if (advertiser == null) {
            result.error("BLE_UNAVAILABLE", "BLE advertising is not supported on this device", null)
            return
        }

        // Stop any existing advertising first
        stopAdvertising()

        // Build manufacturer data:
        // [1 byte platform=0 (Android)] [4 bytes IPv4] [2 bytes port] [UTF-8 name]
        val ipParts = ip.split(".").mapNotNull { it.toIntOrNull()?.toByte() }
        val nameBytes = name.toByteArray(Charsets.UTF_8)
        val mfData = ByteBuffer.allocate(1 + 4 + 2 + nameBytes.size).apply {
            put(0.toByte()) // platform: Android
            if (ipParts.size == 4) {
                put(ipParts.toByteArray())
            } else {
                put(byteArrayOf(0, 0, 0, 0))
            }
            put(((port shr 8) and 0xFF).toByte())
            put((port and 0xFF).toByte())
            put(nameBytes)
        }.array()

        val settings = AdvertiseSettings.Builder()
            .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_LATENCY)
            .setConnectable(false)
            .setTimeout(0) // Advertise indefinitely
            .setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_HIGH)
            .build()

        val data = AdvertiseData.Builder()
            .addServiceUuid(ParcelUuid(SERVICE_UUID))
            .addManufacturerData(MANUFACTURER_ID, mfData)
            .setIncludeDeviceName(false) // Name is in manufacturer data
            .build()

        advertiseCallback = object : AdvertiseCallback() {
            override fun onStartSuccess(settingsInEffect: AdvertiseSettings?) {
                result.success(true)
            }

            override fun onStartFailure(errorCode: Int) {
                result.error("ADVERTISE_FAILED", "BLE advertising failed with error code: $errorCode", null)
            }
        }

        advertiser?.startAdvertising(settings, data, advertiseCallback)
    }

    private fun stopAdvertising() {
        advertiseCallback?.let { callback ->
            try {
                advertiser?.stopAdvertising(callback)
            } catch (_: Exception) {
                // Ignore — adapter may already be off
            }
        }
        advertiseCallback = null
    }
}
