import AVFoundation
import Flutter
import Photos
import UIKit

/**
 iOS media scanning plugin.

 Two sources are queried:
   1. PHPhotoLibrary — Camera Roll videos (requires Photos permission).
      Returns metadata via PHAsset + exports a local URL via AVURLAsset.
   2. Documents directory — files the user imported via share sheet / Files app.
      Scanned recursively with AVURLAsset for duration/resolution.

 Channel : mx_video/media_scanner
 Methods : queryVideos, queryAudios, getStorageRoots
 */
@objc class MediaLibraryPlugin: NSObject, FlutterPlugin {

    // MARK: – Registration

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "mx_video/media_scanner",
            binaryMessenger: registrar.messenger()
        )
        let instance = MediaLibraryPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    // MARK: – Dispatch

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "queryVideos":
            queryAllVideos(result: result)
        case "queryAudios":
            queryDocumentAudios(result: result)
        case "getStorageRoots":
            result([documentsPath()])
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: – Video query (PHPhotoLibrary + Documents)

    private func queryAllVideos(result: @escaping FlutterResult) {
        var all: [[String: Any?]] = []

        let group = DispatchGroup()

        // 1. Documents directory (always accessible, no permission needed)
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            let docs = self.scanDirectory(
                path: self.documentsPath(),
                mimePrefix: "video/",
                validExtensions: ["mp4", "mkv", "mov", "avi", "m4v", "wmv", "flv", "3gp", "webm"]
            )
            all.append(contentsOf: docs)
            group.leave()
        }

        // 2. PHPhotoLibrary Camera Roll
        group.enter()
        fetchPhotoLibraryVideos { items in
            all.append(contentsOf: items)
            group.leave()
        }

        group.notify(queue: .main) {
            result(all)
        }
    }

    // MARK: – Audio query (Documents only)

    private func queryDocumentAudios(result: @escaping FlutterResult) {
        DispatchQueue.global(qos: .userInitiated).async {
            let items = self.scanDirectory(
                path: self.documentsPath(),
                mimePrefix: "audio/",
                validExtensions: ["mp3", "aac", "flac", "ogg", "wav", "m4a", "wma", "opus"]
            )
            DispatchQueue.main.async { result(items) }
        }
    }

    // MARK: – PHPhotoLibrary

    private func fetchPhotoLibraryVideos(completion: @escaping ([[String: Any?]]) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch status {
        case .authorized, .limited:
            performPhotoLibraryFetch(completion: completion)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] granted in
                if granted == .authorized || granted == .limited {
                    self?.performPhotoLibraryFetch(completion: completion)
                } else {
                    completion([])
                }
            }
        default:
            completion([])
        }
    }

    private func performPhotoLibraryFetch(completion: @escaping ([[String: Any?]]) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

        let assets = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        var results: [[String: Any?]] = []
        let group = DispatchGroup()

        assets.enumerateObjects { asset, _, _ in
            group.enter()

            let options = PHVideoRequestOptions()
            options.version = .original
            options.isNetworkAccessAllowed = false
            options.deliveryMode = .fastFormat

            PHImageManager.default().requestAVAsset(
                forVideo: asset,
                options: options
            ) { avAsset, _, info in
                defer { group.leave() }

                guard
                    let urlAsset = avAsset as? AVURLAsset,
                    urlAsset.url.isFileURL
                else { return }

                let path = urlAsset.url.path
                let folderPath = (path as NSString).deletingLastPathComponent
                let folderName = (folderPath as NSString).lastPathComponent
                let ext = urlAsset.url.pathExtension.lowercased()
                let fileSize = self.fileSize(at: path)
                let durationMs = Int((asset.duration.seconds * 1_000).rounded())

                results.append([
                    "path": path,
                    "name": urlAsset.url.lastPathComponent,
                    "extension": ext,
                    "size": fileSize,
                    "duration": durationMs,
                    "width": asset.pixelWidth,
                    "height": asset.pixelHeight,
                    "folderPath": folderPath,
                    "folderName": folderName,
                    "dateModified": Int64(
                        (asset.creationDate?.timeIntervalSince1970 ?? 0) * 1_000
                    ),
                    "mimeType": "video/\(ext)",
                ])
            }
        }

        group.notify(queue: .global()) {
            completion(results)
        }
    }

    // MARK: – Documents directory scanner

    /**
     Recursively walks a directory and returns all files whose extension matches
     [validExtensions]. Uses AVURLAsset to extract duration and resolution without
     fully decoding the file.
     */
    private func scanDirectory(
        path: String,
        mimePrefix: String,
        validExtensions: [String]
    ) -> [[String: Any?]] {
        var results: [[String: Any?]] = []
        let fm = FileManager.default

        guard
            let enumerator = fm.enumerator(
                at: URL(fileURLWithPath: path),
                includingPropertiesForKeys: [.fileSizeKey, .contentModificationDateKey],
                options: [.skipsHiddenFiles]
            )
        else { return results }

        for case let fileURL as URL in enumerator {
            let ext = fileURL.pathExtension.lowercased()
            guard validExtensions.contains(ext) else { continue }

            let filePath = fileURL.path
            let folderPath = fileURL.deletingLastPathComponent().path
            let folderName = fileURL.deletingLastPathComponent().lastPathComponent

            // File attributes
            let attrs = try? fm.attributesOfItem(atPath: filePath)
            let sizeBytes = (attrs?[.size] as? Int64) ?? 0
            let modDate = (attrs?[.modificationDate] as? Date) ?? Date()
            let modMs = Int64(modDate.timeIntervalSince1970 * 1_000)

            // Media metadata via AVURLAsset (cheap header-only read)
            let asset = AVURLAsset(url: fileURL, options: [AVURLAssetPreferPreciseDurationAndTimingKey: false])
            let durationMs = Int((asset.duration.seconds * 1_000).rounded())

            var width = 0, height = 0
            if let track = asset.tracks(withMediaType: .video).first {
                let size = track.naturalSize.applying(track.preferredTransform)
                width = Int(abs(size.width))
                height = Int(abs(size.height))
            }

            results.append([
                "path": filePath,
                "name": fileURL.lastPathComponent,
                "extension": ext,
                "size": sizeBytes,
                "duration": durationMs,
                "width": width,
                "height": height,
                "folderPath": folderPath,
                "folderName": folderName,
                "dateModified": modMs,
                "mimeType": "\(mimePrefix)\(ext)",
            ])
        }

        return results
    }

    // MARK: – Helpers

    private func documentsPath() -> String {
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            ?? NSHomeDirectory() + "/Documents"
    }

    private func fileSize(at path: String) -> Int64 {
        (try? FileManager.default.attributesOfItem(atPath: path))?[.size] as? Int64 ?? 0
    }
}
