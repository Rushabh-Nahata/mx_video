import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        // Register the media library scanner plugin.
        MediaLibraryPlugin.register(with: self.registrar(forPlugin: "MediaLibraryPlugin")!)
        // Register the BLE advertiser plugin for cross-platform device discovery.
        BleAdvertiserPlugin.register(with: self.registrar(forPlugin: "BleAdvertiserPlugin")!)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
