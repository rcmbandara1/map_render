import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../providers/live_map_provider.dart';

class LiveMapPage extends StatefulWidget {
  const LiveMapPage({super.key, required this.deviceId});

  final String deviceId;

  @override
  State<LiveMapPage> createState() => _LiveMapPageState();
}

class _LiveMapPageState extends State<LiveMapPage> {
  final mapController = MapController();
  LatLng? _lastMoved;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LiveMapProvider>().startTracking(widget.deviceId);
    });
  }

  @override
  void dispose() {
    context.read<LiveMapProvider>().stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LiveMapProvider>();
    final markerPos = provider.markerLatLng ?? const LatLng(6.9271, 79.8612);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final current = provider.markerLatLng;
      if (current == null) return;
      if (_lastMoved == current) return;
      _lastMoved = current;
      mapController.move(current, mapController.camera.zoom);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Live Track ${widget.deviceId}'),
        actions: [
          IconButton(
            tooltip: 'Reconnect',
            onPressed: provider.isLoading ? null : provider.reconnect,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: markerPos,
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.yourcompany.tracker',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: markerPos,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_on, size: 40),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Connected: ${provider.isConnected ? "YES" : "NO"}   '
                  'Fix: ${provider.gpsFix ? "YES" : "NO"}   '
                  'Satellites: ${provider.satNos}   '
                  'Lat: ${markerPos.latitude.toStringAsFixed(6)}  '
                  'Lon: ${markerPos.longitude.toStringAsFixed(6)}'
                  '${provider.errorMessage == null ? "" : "\n${provider.errorMessage}"}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
