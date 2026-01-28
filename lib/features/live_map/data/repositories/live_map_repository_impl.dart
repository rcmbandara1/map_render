import '../../domain/entities/live_location.dart';
import '../../domain/repositories/live_map_repository.dart';
import '../datasources/live_map_ws_datasource.dart';

class LiveMapRepositoryImpl implements LiveMapRepository {
  LiveMapRepositoryImpl(this._wsDataSource);

  final LiveMapWsDataSource _wsDataSource;

  @override
  Stream<LiveLocation> subscribeToDevice(String deviceId) {
    return _wsDataSource.subscribeToDevice(deviceId).map((m) => m.toEntity());
  }

  @override
  Future<void> dispose() => _wsDataSource.dispose();
}

