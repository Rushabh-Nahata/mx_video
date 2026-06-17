package com.example.mx_video

import android.content.Context
import android.os.Build
import android.provider.MediaStore
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/**
 * Queries the Android [MediaStore] content provider for video and audio files.
 *
 * Why MediaStore instead of a filesystem walk:
 *   - O(1) — the OS maintains the index; no need to traverse directories.
 *   - Includes files on external SD cards and download folders automatically.
 *   - Returns metadata (duration, resolution, size) without opening each file.
 *   - Survives across app launches without re-scanning.
 *
 * Channel: mx_video/media_scanner
 * Methods: queryVideos, queryAudios, getStorageRoots
 */
class MediaStorePlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    // ── FlutterPlugin lifecycle ─────────────────────────────────────────────

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // ── MethodChannel dispatch ──────────────────────────────────────────────

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "queryVideos" -> scope.launch {
                val videos = queryVideos()
                withContext(Dispatchers.Main) { result.success(videos) }
            }
            "queryAudios" -> scope.launch {
                val audios = queryAudios()
                withContext(Dispatchers.Main) { result.success(audios) }
            }
            "getStorageRoots" -> result.success(getStorageRoots())
            else -> result.notImplemented()
        }
    }

    // ── Video query ─────────────────────────────────────────────────────────

    private fun queryVideos(): List<Map<String, Any?>> {
        val videos = mutableListOf<Map<String, Any?>>()

        val uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            MediaStore.Video.Media.getContentUri(MediaStore.VOLUME_EXTERNAL)
        } else {
            MediaStore.Video.Media.EXTERNAL_CONTENT_URI
        }

        val projection = arrayOf(
            MediaStore.Video.Media._ID,
            MediaStore.Video.Media.DATA,
            MediaStore.Video.Media.DISPLAY_NAME,
            MediaStore.Video.Media.SIZE,
            MediaStore.Video.Media.DURATION,
            MediaStore.Video.Media.WIDTH,
            MediaStore.Video.Media.HEIGHT,
            MediaStore.Video.Media.BUCKET_DISPLAY_NAME,
            MediaStore.Video.Media.DATE_MODIFIED,
            MediaStore.Video.Media.MIME_TYPE,
        )

        val sortOrder = "${MediaStore.Video.Media.DATE_MODIFIED} DESC"

        context.contentResolver.query(uri, projection, null, null, sortOrder)?.use { cursor ->
            val dataIdx = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATA)
            val nameIdx = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DISPLAY_NAME)
            val sizeIdx = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.SIZE)
            val durIdx  = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DURATION)
            val wIdx    = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.WIDTH)
            val hIdx    = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.HEIGHT)
            val buckIdx = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.BUCKET_DISPLAY_NAME)
            val dateIdx = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATE_MODIFIED)
            val mimeIdx = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.MIME_TYPE)

            while (cursor.moveToNext()) {
                val path = cursor.getString(dataIdx) ?: continue
                if (path.isBlank()) continue

                val folderPath = path.substringBeforeLast("/", missingDelimiterValue = "/")
                val ext = path.substringAfterLast(".", missingDelimiterValue = "").lowercase()

                videos += mapOf(
                    "path"          to path,
                    "name"          to (cursor.getString(nameIdx) ?: path.substringAfterLast("/")),
                    "extension"     to ext,
                    "size"          to cursor.getLong(sizeIdx),
                    "duration"      to cursor.getLong(durIdx),
                    "width"         to cursor.getInt(wIdx),
                    "height"        to cursor.getInt(hIdx),
                    "folderPath"    to folderPath,
                    "folderName"    to (cursor.getString(buckIdx) ?: folderPath.substringAfterLast("/")),
                    "dateModified"  to (cursor.getLong(dateIdx) * 1000L),  // sec → ms
                    "mimeType"      to (cursor.getString(mimeIdx) ?: "video/$ext"),
                )
            }
        }

        return videos
    }

    // ── Audio query ─────────────────────────────────────────────────────────

    private fun queryAudios(): List<Map<String, Any?>> {
        val audios = mutableListOf<Map<String, Any?>>()

        val uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL)
        } else {
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
        }

        val projection = arrayOf(
            MediaStore.Audio.Media.DATA,
            MediaStore.Audio.Media.DISPLAY_NAME,
            MediaStore.Audio.Media.SIZE,
            MediaStore.Audio.Media.DURATION,
            MediaStore.Audio.Media.BUCKET_DISPLAY_NAME,
            MediaStore.Audio.Media.DATE_MODIFIED,
            MediaStore.Audio.Media.MIME_TYPE,
        )

        context.contentResolver.query(uri, projection, null, null, null)?.use { cursor ->
            val dataIdx = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA)
            val nameIdx = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DISPLAY_NAME)
            val sizeIdx = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.SIZE)
            val durIdx  = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DURATION)
            val buckIdx = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.BUCKET_DISPLAY_NAME)
            val dateIdx = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DATE_MODIFIED)
            val mimeIdx = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.MIME_TYPE)

            while (cursor.moveToNext()) {
                val path = cursor.getString(dataIdx) ?: continue
                if (path.isBlank()) continue

                val folderPath = path.substringBeforeLast("/", missingDelimiterValue = "/")
                val ext = path.substringAfterLast(".", missingDelimiterValue = "").lowercase()

                audios += mapOf(
                    "path"          to path,
                    "name"          to (cursor.getString(nameIdx) ?: path.substringAfterLast("/")),
                    "extension"     to ext,
                    "size"          to cursor.getLong(sizeIdx),
                    "duration"      to cursor.getLong(durIdx),
                    "width"         to 0,
                    "height"        to 0,
                    "folderPath"    to folderPath,
                    "folderName"    to (cursor.getString(buckIdx) ?: folderPath.substringAfterLast("/")),
                    "dateModified"  to (cursor.getLong(dateIdx) * 1000L),
                    "mimeType"      to (cursor.getString(mimeIdx) ?: "audio/$ext"),
                )
            }
        }

        return audios
    }

    // ── Storage roots ───────────────────────────────────────────────────────

    private fun getStorageRoots(): List<String> {
        val roots = mutableListOf("/storage/emulated/0")

        // External volumes (SD card, USB OTG) — Android 9+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            try {
                val externalDirs = context.getExternalFilesDirs(null)
                for (dir in externalDirs) {
                    if (dir == null) continue
                    // Convert app-specific path to volume root
                    // e.g. /storage/XXXX-XXXX/Android/data/... → /storage/XXXX-XXXX
                    val parts = dir.absolutePath.split("/Android/")
                    if (parts.size > 1 && !roots.contains(parts[0])) {
                        roots += parts[0]
                    }
                }
            } catch (_: Exception) { /* Ignore */ }
        }

        return roots
    }

    companion object {
        const val CHANNEL = "mx_video/media_scanner"
    }
}
