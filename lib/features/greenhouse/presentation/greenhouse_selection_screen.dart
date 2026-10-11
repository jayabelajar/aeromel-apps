import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/app_state.dart';

class GreenhouseSelectionScreen extends ConsumerWidget {
  const GreenhouseSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                const Icon(LucideIcons.sprout, color: AppColors.primaryGreen),
                const SizedBox(width: 10),
                Expanded(child: Text('Pilih Greenhouse', style: Theme.of(context).textTheme.displaySmall)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih lokasi aktif untuk dashboard, AI insights, kontrol, dan histori.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.secondaryText),
            ),
            const SizedBox(height: 24),
            ...demoGreenhouses.map(
              (greenhouse) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: AppCard(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      ref.read(activeGreenhouseProvider.notifier).state = greenhouse;
                      context.go('/home');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(greenhouse.name, style: Theme.of(context).textTheme.titleLarge)),
                            StatusBadge(
                              label: greenhouse.deviceOnline ? 'Online' : 'Offline',
                              severity: greenhouse.deviceOnline ? Severity.success : Severity.danger,
                              icon: greenhouse.deviceOnline ? LucideIcons.wifi : LucideIcons.wifiOff,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            StatusBadge(label: greenhouse.stage, severity: Severity.info, icon: LucideIcons.leaf),
                            StatusBadge(label: greenhouse.variety, severity: Severity.success, icon: LucideIcons.apple),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Tanam ${DateFormat('d MMM yyyy').format(greenhouse.plantingDate)} • Last seen ${DateFormat('HH:mm').format(greenhouse.lastSeen)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
