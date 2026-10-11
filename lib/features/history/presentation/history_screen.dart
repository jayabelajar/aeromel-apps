import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/metric_chart.dart';
import '../../../core/widgets/section_header.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/app_state.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRange = ref.watch(selectedHistoryRangeProvider);
    const ranges = ['Hari ini', '7 hari', '30 hari', 'Custom'];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('History & Analytics', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 8),
            Text('Tren sensor ditampilkan sesuai timestamp lokal pengguna.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.secondaryText)),
            const SizedBox(height: 18),
            SegmentedButton<String>(
              segments: ranges.map((range) => ButtonSegment(value: range, label: Text(range))).toList(),
              selected: {selectedRange},
              onSelectionChanged: (value) => ref.read(selectedHistoryRangeProvider.notifier).state = value.first,
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Ringkasan'),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _SummaryCard(width: width, title: 'EC rata-rata', value: '2.08 mS/cm', icon: LucideIcons.activity),
                    _SummaryCard(width: width, title: 'pH rata-rata', value: '6.08', icon: LucideIcons.flaskConical),
                    _SummaryCard(width: width, title: 'Suhu maks', value: '30 °C', icon: LucideIcons.thermometer),
                    _SummaryCard(width: width, title: 'Level min', value: '38%', icon: LucideIcons.gauge),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            _ChartCard(title: 'EC trend', unit: 'mS/cm', points: ecTrend, color: AppColors.primaryGreen),
            const SizedBox(height: 14),
            _ChartCard(title: 'pH trend', unit: '', points: phTrend, color: AppColors.info),
            const SizedBox(height: 14),
            _ChartCard(title: 'Temperature trend', unit: '°C', points: tempTrend, color: AppColors.warning),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Aktivitas aktuator'),
            const SizedBox(height: 12),
            ...['Misting otomatis berjalan 18 detik', 'Konfigurasi interval diperbarui', 'Emergency stop diuji admin'].map(
              (activity) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  child: Row(
                    children: [
                      const Icon(LucideIcons.history, color: AppColors.primaryGreen),
                      const SizedBox(width: 12),
                      Expanded(child: Text(activity, style: Theme.of(context).textTheme.titleMedium)),
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

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.unit, required this.points, required this.color});

  final String title;
  final String unit;
  final List<MetricPoint> points;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          MetricChart(points: points, unit: unit, color: color),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.width, required this.title, required this.value, required this.icon});

  final double width;
  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final itemWidth = width >= 720 ? (width - 36) / 4 : (width - 12) / 2;
    return SizedBox(
      width: itemWidth,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryGreen),
            const SizedBox(height: 10),
            Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText)),
            const SizedBox(height: 4),
            FittedBox(child: Text(value, style: Theme.of(context).textTheme.titleLarge)),
          ],
        ),
      ),
    );
  }
}
