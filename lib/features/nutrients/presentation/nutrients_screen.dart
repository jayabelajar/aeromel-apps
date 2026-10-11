import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/models/app_models.dart';

class NutrientsScreen extends StatelessWidget {
  const NutrientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final current = demoRecommendations.first;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('AI Nutrient Insights', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 8),
            Text(
              'Analisis nutrisi berbasis sensor. Rekomendasi tidak menjalankan dosing otomatis pada MVP.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.secondaryText),
            ),
            const SizedBox(height: 18),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StatusBadge(label: 'Fase Fruiting', severity: Severity.info, icon: LucideIcons.leaf),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _RangeTile(label: 'EC aktual', value: '2.15', unit: 'mS/cm', target: 'Target 2.20 - 2.60')),
                      const SizedBox(width: 12),
                      Expanded(child: _RangeTile(label: 'pH aktual', value: '6.1', unit: '', target: 'Target 5.8 - 6.5')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Rekomendasi terbaru'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusBadge(label: current.status, severity: Severity.warning, icon: LucideIcons.sparkles),
                  const SizedBox(height: 14),
                  Text(current.action, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text(current.explanation, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText)),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatusBadge(label: current.engineVersion, severity: Severity.info, icon: LucideIcons.cpu),
                      StatusBadge(label: DateFormat('HH:mm, d MMM').format(current.createdAt), severity: Severity.success, icon: LucideIcons.clock),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(LucideIcons.refreshCw),
                          label: const Text('Analisis ulang'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(LucideIcons.check),
                          label: const Text('Acknowledge'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Histori rekomendasi'),
            const SizedBox(height: 12),
            ...demoRecommendations.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  child: Row(
                    children: [
                      Icon(item.acknowledged ? LucideIcons.checkCircle2 : LucideIcons.circleDashed, color: item.acknowledged ? AppColors.success : AppColors.warning),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.status, style: Theme.of(context).textTheme.titleMedium),
                            Text(item.action, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText)),
                          ],
                        ),
                      ),
                    ],
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

class _RangeTile extends StatelessWidget {
  const _RangeTile({required this.label, required this.value, required this.unit, required this.target});

  final String label;
  final String value;
  final String unit;
  final String target;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondaryText)),
          const SizedBox(height: 6),
          FittedBox(child: Text('$value $unit', style: Theme.of(context).textTheme.titleLarge)),
          const SizedBox(height: 6),
          Text(target, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}
