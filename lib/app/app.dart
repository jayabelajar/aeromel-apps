import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class MelonGrowApp extends StatelessWidget {
  const MelonGrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MelonGrow AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
    );
  }
}
