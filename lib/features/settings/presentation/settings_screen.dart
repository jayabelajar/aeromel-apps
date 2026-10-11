import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../shared/providers/app_state.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.lightGreen,
                  child: Text('OP', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primaryGreen)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Operator Greenhouse', style: Theme.of(context).textTheme.titleLarge),
                      Text('operator@melongrow.ai', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SettingTile(icon: LucideIcons.bell, title: 'Preferensi notifikasi', subtitle: 'Critical dan warning aktif'),
          _SettingTile(icon: LucideIcons.sun, title: 'Tema aplikasi', subtitle: 'Light theme'),
          _SettingTile(icon: LucideIcons.ruler, title: 'Unit preferensi', subtitle: 'Metric'),
          _SettingTile(icon: LucideIcons.warehouse, title: 'Ganti greenhouse', subtitle: 'Pilih greenhouse aktif', onTap: () => context.go('/greenhouses')),
          _SettingTile(icon: LucideIcons.cpu, title: 'Device management', subtitle: 'Lihat perangkat terdaftar', onTap: () => context.push('/devices')),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
            icon: const Icon(LucideIcons.logOut),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.icon, required this.title, required this.subtitle, this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: ListTile(
          minVerticalPadding: 14,
          leading: Icon(icon, color: AppColors.primaryGreen),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(LucideIcons.chevronRight),
          onTap: onTap,
        ),
      ),
    );
  }
}
