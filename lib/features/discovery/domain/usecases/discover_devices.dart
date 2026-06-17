import '../../../transfer/domain/entities/peer_device.dart';
import '../repositories/discovery_repository.dart';

class DiscoverDevices {
  const DiscoverDevices(this._repository);
  final DiscoveryRepository _repository;

  Stream<List<PeerDevice>> call() => _repository.discoverDevices();
}
