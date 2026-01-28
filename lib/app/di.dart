import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../features/live_map/data/datasources/live_map_ws_datasource.dart';
import '../features/live_map/data/repositories/live_map_repository_impl.dart';
import '../features/live_map/domain/usecases/track_device_stream.dart';
import '../features/live_map/presentation/providers/live_map_provider.dart';

LiveMapProvider buildLiveMapProvider() {
  final wsUrl = dotenv.env['WS_URL'];
  if (wsUrl == null || wsUrl.isEmpty) {
    throw StateError('Missing WS_URL in .env');
  }
  final wsUrlValue = wsUrl;

  final wsDataSource = LiveMapWsDataSource(
    wsUrl: wsUrlValue,
    channelFactory: (uri) => WebSocketChannel.connect(uri),
  );

  final repository = LiveMapRepositoryImpl(wsDataSource);
  final trackDeviceStream = TrackDeviceStream(repository);

  return LiveMapProvider(trackDeviceStream: trackDeviceStream);
}
