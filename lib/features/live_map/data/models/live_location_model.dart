import '../../domain/entities/live_location.dart';

class LiveLocationModel {
  const LiveLocationModel({
    required this.latitude,
    required this.longitude,
    required this.gpsFix,
    required this.satelliteCount,
  });

  factory LiveLocationModel.fromUpdatePayload(Map<String, dynamic> payload) {
    final lat = payload['lat'] ?? payload['la'];
    final lon = payload['lon'] ?? payload['lo'];
    if (lat == null || lon == null) {
      throw const FormatException('Missing lat/lon in payload');
    }

    final gpsFixValue = payload['gps_fix'] ?? payload['fx'];
    final satNosValue = payload['sat_nos'] ?? payload['sn'];

    return LiveLocationModel(
      latitude: (lat as num).toDouble(),
      longitude: (lon as num).toDouble(),
      gpsFix: gpsFixValue == true ||
          gpsFixValue == 1 ||
          gpsFixValue == '1' ||
          gpsFixValue == 'true',
      satelliteCount: (satNosValue ?? 0) is int
          ? (satNosValue ?? 0) as int
          : (satNosValue as num?)?.toInt() ?? 0,
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
