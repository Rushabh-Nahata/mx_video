import '../entities/peer_device.dart';
import '../entities/transfer_job.dart';
import '../repositories/transfer_repository.dart';

class SendFile {
  const SendFile(this._repository);
  final TransferRepository _repository;

  Future<TransferJobEntity> call(PeerDevice peer, String filePath) =>
      _repository.sendFile(peer, filePath);
}

class SendFiles {
  const SendFiles(this._repository);
  final TransferRepository _repository;

  Future<List<TransferJobEntity>> call(
          PeerDevice peer, List<String> filePaths) =>
      _repository.sendFiles(peer, filePaths);
}
