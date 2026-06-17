import '../entities/peer_device.dart';
import '../repositories/transfer_repository.dart';

class DiscoverPeers {
  const DiscoverPeers(this._repository);
  final TransferRepository _repository;

  Stream<List<PeerDevice>> call() => _repository.discoverPeers();
}
