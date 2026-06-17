/// Base class for all infrastructure-layer exceptions.
/// These are caught at repository boundaries and converted to [Failure].
class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException: $message${cause != null ? ' (caused by: $cause)' : ''}';
}

class FileSystemException extends AppException {
  const FileSystemException(super.message, {super.cause});
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.cause});
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause});
}

class TransferException extends AppException {
  const TransferException(super.message, {super.cause});
}
