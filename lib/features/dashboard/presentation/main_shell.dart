import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) => shell.goBranch(index, initialLocation: index == shell.currentIndex),
        destinations: const [
          NavigationDestination(icon: Icon(LucideIcons.home), label: 'Home'),
          NavigationDestination(icon: Icon(LucideIcons.sparkles), label: 'AI Insights'),
          NavigationDestination(icon: Icon(LucideIcons.slidersHorizontal), label: 'Control'),
          NavigationDestination(icon: Icon(LucideIcons.lineChart), label: 'History'),
        ],
      ),
    );
  }
}
