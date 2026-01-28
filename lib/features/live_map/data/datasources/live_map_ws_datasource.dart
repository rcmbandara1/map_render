import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/live_location_model.dart';

class LiveMapWsDataSource {
  LiveMapWsDataSource({
    required String wsUrl,
    required WebSocketChannel Function(Uri uri) channelFactory,
  })  : _wsUrl = wsUrl,
        _channelFactory = channelFactory;

  final String _wsUrl;
  final WebSocketChannel Function(Uri uri) _channelFactory;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  Stream<LiveLocationModel> subscribeToDevice(String deviceId) {
    final controller = StreamController<LiveLocationModel>(onCancel: () async {
      await _disposeInternal();
    });

    _channel = _channelFactory(Uri.parse(_wsUrl));

    _subscription = _channel!.stream.listen(
      (event) {
        try {
          final decoded = jsonDecode(event as String);
          if (decoded is! Map<String, dynamic>) return;

          final type = decoded['type'];
          if (type == 'hello') return;

          if (type == 'update' && decoded['device_id'] == deviceId) {
            final payload = (decoded['payload'] as Map?)?.cast<String, dynamic>() ??
                const <String, dynamic>{};
            controller.add(LiveLocationModel.fromUpdatePayload(payload));
          }
        } catch (e, st) {
          controller.addError(e, st);
        }
      },
      onError: (Object e, StackTrace st) => controller.addError(e, st),
      onDone: () {
        if (!controller.isClosed) controller.close();
      },
      cancelOnError: false,
    );

    Future<void>.delayed(const Duration(milliseconds: 300), () {
      _channel?.sink.add(jsonEncode({'type': 'subscribe', 'device_id': deviceId}));
    });

    return controller.stream;
  }

  Future<void> dispose() => _disposeInternal();

  Future<void> _disposeInternal() async {
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
  }
}

