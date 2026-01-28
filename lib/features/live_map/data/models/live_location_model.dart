import '../../domain/entities/live_location.dart';

class LiveLocationModel {
  const LiveLocationModel({
    required this.latitude,
    required this.longitude,
    required this.gpsFix,
    required this.satelliteCount,
  });

  factory LiveLocationModel.fromUpdatePayload(Map<String, dynamic> payload) {
    final lat = payload['lat'];
    final lon = payload['lon'];
    if (lat == null || lon == null) {
      throw const FormatException('Missing lat/lon in payload');
    }

    return LiveLocationModel(
      latitude: (lat as num).toDouble(),
      longitude: (lon as num).toDouble(),
      gpsFix: payload['gps_fix'] == true,
      satelliteCount: (payload['sat_nos'] ?? 0) is int
          ? (payload['sat_nos'] ?? 0) as int
          : (payload['sat_nos'] as num?)?.toInt() ?? 0,
    );
  }

  final double latitude;
  final double longitude;
  final bool gpsFix;
  final int satelliteCount;

  LiveLocation toEntity() => LiveLocation(
        latitude: latitude,
        longitude: longitude,
        gpsFix: gpsFix,
        satelliteCount: satelliteCount,
      );
}

