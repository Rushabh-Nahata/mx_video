/// Sealed class hierarchy for domain-layer failures.
/// UI and use cases return [Failure] instead of throwing exceptions.
sealed class Failure {
  const Failure(this.message);
  final String message;
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class TransferFailure extends Failure {
  const TransferFailure(super.message);
}

class PlaybackFailure extends Failure {
  const PlaybackFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
