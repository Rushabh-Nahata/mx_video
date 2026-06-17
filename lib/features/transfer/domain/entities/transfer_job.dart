import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_job.freezed.dart';

enum TransferDirection { send, receive }

enum TransferStatus { queued, active, paused, completed, failed, cancelled }

@freezed
abstract class TransferJobEntity with _$TransferJobEntity {
  const factory TransferJobEntity({
    required int id,
    required String peerName,
    required String peerIp,
    required String fileName,
    required int fileSize,
    @Default(0) int bytesTransferred,
    required TransferDirection direction,
    @Default(TransferStatus.queued) TransferStatus status,
    String? checksum,
    int? startedAt,
    int? finishedAt,
    String? savePath,
    String? errorMessage,
    /// Current transfer speed in bytes per second.
    @Default(0) int speedBytesPerSec,
  }) = _TransferJobEntity;

  const TransferJobEntity._();

  double get progress =>
      fileSize > 0 ? bytesTransferred / fileSize : 0.0;

  bool get isActive => status == TransferStatus.active;
  bool get isCompleted => status == TransferStatus.completed;
  bool get hasFailed => status == TransferStatus.failed;
  bool get canRetry => hasFailed || status == TransferStatus.cancelled;

  /// Human-readable speed string.
  String get speedFormatted {
    if (speedBytesPerSec <= 0) return '';
    if (speedBytesPerSec >= 1024 * 1024) {
      return '${(speedBytesPerSec / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    }
    if (speedBytesPerSec >= 1024) {
      return '${(speedBytesPerSec / 1024).toStringAsFixed(0)} KB/s';
    }
    return '$speedBytesPerSec B/s';
  }

  /// Estimated time remaining.
  Duration? get eta {
    if (speedBytesPerSec <= 0 || !isActive) return null;
    final remaining = fileSize - bytesTransferred;
    return Duration(seconds: remaining ~/ speedBytesPerSec);
  }
}
