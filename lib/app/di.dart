import 'package:web_socket_channel/web_socket_channel.dart';

import '../features/live_map/data/datasources/live_map_ws_datasource.dart';
import '../features/live_map/data/repositories/live_map_repository_impl.dart';
import '../features/live_map/domain/usecases/track_device_stream.dart';
import '../features/live_map/presentation/providers/live_map_provider.dart';

LiveMapProvider buildLiveMapProvider() {
  const wsUrl = 'ws://68.233.96.14/ws?token=manujaputha';

  final wsDataSource = LiveMapWsDataSource(
    wsUrl: wsUrl,
    channelFactory: (uri) => WebSocketChannel.connect(uri),
  );

  final repository = LiveMapRepositoryImpl(wsDataSource);
  final trackDeviceStream = TrackDeviceStream(repository);

  return LiveMapProvider(trackDeviceStream: trackDeviceStream);
}

