import '../entities/live_location.dart';
import '../repositories/live_map_repository.dart';

class TrackDeviceStream {
  const TrackDeviceStream(this._repository);

  final LiveMapRepository _repository;

  Stream<LiveLocation> call(String deviceId) {
    return _repository.subscribeToDevice(deviceId);
  }
}

