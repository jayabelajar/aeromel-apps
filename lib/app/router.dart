import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/greenhouse/presentation/greenhouse_selection_screen.dart';
import '../features/nutrients/presentation/nutrients_screen.dart';
import '../features/misting/presentation/misting_screen.dart';
import '../features/history/presentation/history_screen.dart';
import '../features/alerts/presentation/notifications_screen.dart';
import '../features/devices/presentation/device_management_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/dashboard/presentation/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/greenhouses', builder: (context, state) => const GreenhouseSelectionScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => MainShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (context, state) => const DashboardScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/insights', builder: (context, state) => const NutrientsScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/control', builder: (context, state) => const MistingScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/history', builder: (context, state) => const HistoryScreen())]),
      ],
    ),
    GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
    GoRoute(path: '/devices', builder: (context, state) => const DeviceManagementScreen()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Halaman tidak ditemukan: ${state.uri}')),
  ),
);
