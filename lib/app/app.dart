import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class AeroMelApp extends StatelessWidget {
  const AeroMelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AeroMel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
    );
  }
}
