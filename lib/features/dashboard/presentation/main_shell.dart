import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../app/theme/app_colors.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Padding(padding: const EdgeInsets.only(bottom: 92), child: shell),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .95),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkGreen.withValues(alpha: .12),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    _NavItem(
                      label: 'Home',
                      icon: LucideIcons.home,
                      color: AppColors.primaryGreen,
                      selected: shell.currentIndex == 0,
                      onTap: () => _go(0),
                    ),
                    _NavItem(
                      label: 'Insight',
                      icon: LucideIcons.sparkles,
                      color: AppColors.info,
                      selected: shell.currentIndex == 1,
                      onTap: () => _go(1),
                    ),
                    _NavItem(
                      label: 'Kontrol',
                      icon: LucideIcons.slidersHorizontal,
                      color: AppColors.warning,
                      selected: shell.currentIndex == 2,
                      onTap: () => _go(2),
                    ),
                    _NavItem(
                      label: 'Histori',
                      icon: LucideIcons.lineChart,
                      color: const Color(0xFF7C3AED),
                      selected: shell.currentIndex == 3,
                      onTap: () => _go(3),
                    ),
                    _NavItem(
                      label: 'Profil',
                      icon: LucideIcons.user,
                      color: const Color(0xFFDB2777),
                      selected: shell.currentIndex == 4,
                      onTap: () => _go(4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _go(int index) {
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Tooltip(
        message: label,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: selected
                  ? color.withValues(alpha: .12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected ? color : AppColors.secondaryText,
                ),
                const SizedBox(height: 4),
                FittedBox(
                  child: Text(
                    label,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected ? color : AppColors.secondaryText,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
