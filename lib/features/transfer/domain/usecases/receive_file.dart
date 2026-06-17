import '../repositories/transfer_repository.dart';

/// Receiving is handled server-side automatically once [TransferRepository.startServer]
/// is called. This use case starts the server and begins advertising.
class ReceiveFile {
  const ReceiveFile(this._repository);
  final TransferRepository _repository;

  Future<void> call() async {
    await _repository.startServer();
    await _repository.startAdvertising();
  }
}
