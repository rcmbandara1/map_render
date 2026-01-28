import 'package:flutter/material.dart';

import 'features/live_map/presentation/pages/live_map_page.dart' as feature;

@Deprecated('Use features/live_map/presentation/pages/live_map_page.dart')
class LiveMapPage extends StatelessWidget {
  const LiveMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const feature.LiveMapPage();
  }
}
