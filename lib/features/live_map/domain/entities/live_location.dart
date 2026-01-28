class LiveLocation {
  const LiveLocation({
    required this.latitude,
    required this.longitude,
    required this.gpsFix,
    required this.satelliteCount,
  });

  final double latitude;
  final double longitude;
  final bool gpsFix;
  final int satelliteCount;
}

