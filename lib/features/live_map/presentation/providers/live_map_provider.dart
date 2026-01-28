import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/live_location.dart';
import '../../domain/usecases/track_device_stream.dart';

class LiveMapProvider extends ChangeNotifier {
  LiveMapProvider({required TrackDeviceStream trackDeviceStream})
      : _trackDeviceStream = trackDeviceStream;

  final TrackDeviceStream _trackDeviceStream;

  StreamSubscription<LiveLocation>? _subscription;
  String? _deviceId;

  bool _isConnected = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool _gpsFix = false;
  int _satNos = 0;
  double? _lat;
  double? _lon;

  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get gpsFix => _gpsFix;
  int get satNos => _satNos;

  LatLng? get markerLatLng =>
      (_lat == null || _lon == null) ? null : LatLng(_lat!, _lon!);

  Future<void> startTracking(String deviceId) async {
    _deviceId = deviceId;
    await _connect();
  }

  Future<void> reconnect() async {
    if (_deviceId == null) return;
    await _connect();
  }

  Future<void> stopTracking() async {
    _deviceId = null;
    await _subscription?.cancel();
    _subscription = null;
    _isConnected = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _connect() async {
    final deviceId = _deviceId;
    if (deviceId == null) return;

    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    await _subscription?.cancel();

    _subscription = _trackDeviceStream(deviceId).listen(
      (location) {
        _isConnected = true;
        _isLoading = false;
        _gpsFix = location.gpsFix;
        _satNos = location.satelliteCount;
        _lat = location.latitude;
        _lon = location.longitude;
        notifyListeners();
      },
      onError: (Object e) {
        _isConnected = false;
        _isLoading = false;
        _errorMessage = e.toString();
        notifyListeners();
      },
      onDone: () {
        _isConnected = false;
        _isLoading = false;
        notifyListeners();
      },
      cancelOnError: false,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

