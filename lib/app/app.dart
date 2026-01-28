import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/live_map/presentation/pages/live_map_page.dart';
import '../features/live_map/presentation/providers/live_map_provider.dart';
import 'di.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LiveMapProvider>(
          create: (_) => buildLiveMapProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Watchdog Tracker',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        home: const LiveMapPage(),
      ),
    );
  }
}

