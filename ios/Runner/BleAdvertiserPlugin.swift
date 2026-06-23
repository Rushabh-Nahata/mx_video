import Flutter
import CoreBluetooth

/// Native iOS plugin for BLE peripheral advertising.
///
/// Allows the app to advertise itself as an MX Video device via BLE
/// so that Android devices can discover it even without shared WiFi.
class BleAdvertiserPlugin: NSObject, FlutterPlugin, CBPeripheralManagerDelegate {

    private var peripheralManager: CBPeripheralManager?
    private var pendingAdvertisementData: [String: Any]?
    private var channel: FlutterMethodChannel?

    static let serviceUuid = CBUUID(string: "a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d")
    static let manufacturerId: UInt16 = 0x4D58 // "MX"

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "mx_video/ble_advertiser",
            binaryMessenger: registrar.messenger()
        )
        let instance = BleAdvertiserPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startAdvertising":
            guard let args = call.arguments as? [String: Any],
                  let name = args["name"] as? String,
                  let ip = args["ip"] as? String,
                  let port = args["port"] as? Int else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing name, ip, or port", details: nil))
                return
            }
            startAdvertising(name: name, ip: ip, port: port, result: result)

        case "stopAdvertising":
            stopAdvertising()
            result(nil)

        case "isAvailable":
            let available = peripheralManager?.state == .poweredOn
            result(available)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func startAdvertising(name: String, ip: String, port: Int, result: @escaping FlutterResult) {
        if peripheralManager == nil {
            peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        }

        // Build manufacturer data:
        // [1 byte platform=1 (iOS)] [4 bytes IPv4] [2 bytes port] [UTF-8 name]
        var data = Data()

        // Platform byte: 1 = iOS
        data.append(UInt8(1))

        // IPv4 bytes
        let ipParts = ip.split(separator: ".").compactMap { UInt8($0) }
        if ipParts.count == 4 {
            data.append(contentsOf: ipParts)
        } else {
            // No valid IP — use 0.0.0.0
            data.append(contentsOf: [0, 0, 0, 0])
        }

        // Port (big-endian)
        data.append(UInt8((port >> 8) & 0xFF))
        data.append(UInt8(port & 0xFF))

        // Device name (UTF-8)
        if let nameData = name.data(using: .utf8) {
            data.append(nameData)
        }

        // CoreBluetooth uses CBAdvertisementDataServiceUUIDsKey for the service UUID.
        // Manufacturer data is encoded as CBAdvertisementDataLocalNameKey + service data.
        // Note: iOS BLE advertising is limited — we advertise service UUID and local name.
        // The IP/port info is provided via a GATT characteristic that scanners can read.
        let advertisementData: [String: Any] = [
            CBAdvertisementDataServiceUUIDsKey: [BleAdvertiserPlugin.serviceUuid],
            CBAdvertisementDataLocalNameKey: name,
        ]

        if peripheralManager?.state == .poweredOn {
            // Add a GATT service with a characteristic containing the connection info
            let characteristic = CBMutableCharacteristic(
                type: CBUUID(string: "a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5e"),
                properties: .read,
                value: data,
                permissions: .readable
            )
            let service = CBMutableService(type: BleAdvertiserPlugin.serviceUuid, primary: true)
            service.characteristics = [characteristic]
            peripheralManager?.removeAllServices()
            peripheralManager?.add(service)

            peripheralManager?.startAdvertising(advertisementData)
            result(true)
        } else {
            // Manager not ready yet — save data and start when powered on.
            pendingAdvertisementData = advertisementData
            result(true)
        }
    }

    private func stopAdvertising() {
        peripheralManager?.stopAdvertising()
        peripheralManager?.removeAllServices()
        pendingAdvertisementData = nil
    }

    // MARK: - CBPeripheralManagerDelegate

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn, let data = pendingAdvertisementData {
            peripheral.startAdvertising(data)
            pendingAdvertisementData = nil
        }

        // Notify Flutter of state changes
        let stateStr: String
        switch peripheral.state {
        case .poweredOn: stateStr = "poweredOn"
        case .poweredOff: stateStr = "poweredOff"
        case .unauthorized: stateStr = "unauthorized"
        case .unsupported: stateStr = "unsupported"
        default: stateStr = "unknown"
        }
        channel?.invokeMethod("onStateChanged", arguments: stateStr)
    }
}
