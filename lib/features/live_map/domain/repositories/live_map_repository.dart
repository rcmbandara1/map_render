import '../entities/live_location.dart';

abstract class LiveMapRepository {
  Stream<LiveLocation> subscribeToDevice(String deviceId);

  Future<void> dispose();
}

