import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/sensor_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/app_state.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greenhouse = ref.watch(activeGreenhouseProvider) ?? demoGreenhouses.first;
    final misting = ref.watch(mistingProvider);
    final latestRecommendation = demoRecommendations.first;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => Future<void>.delayed(const Duration(milliseconds: 500)),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selamat sore', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText)),
                        Text(greenhouse.name, style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: 'Notifikasi',
                    onPressed: () => context.push('/notifications'),
                    icon: const Icon(LucideIcons.bell),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: 'Pengaturan',
                    onPressed: () => context.push('/settings'),
                    icon: const Icon(LucideIcons.settings),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (!greenhouse.deviceOnline)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: StatusBadge(label: 'Perangkat offline, data terbaru ditampilkan sebagai cache', severity: Severity.danger, icon: LucideIcons.wifiOff),
                ),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('Ringkasan greenhouse', style: Theme.of(context).textTheme.titleLarge)),
                        StatusBadge(
                          label: greenhouse.deviceOnline ? 'Live' : 'Cached',
                          severity: greenhouse.deviceOnline ? Severity.success : Severity.warning,
                          icon: greenhouse.deviceOnline ? LucideIcons.radio : LucideIcons.clock,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _InfoRow(label: 'Varietas', value: greenhouse.variety),
                    _InfoRow(label: 'Fase', value: greenhouse.stage),
                    _InfoRow(label: 'Tanggal tanam', value: DateFormat('d MMMM yyyy').format(greenhouse.plantingDate)),
                    _InfoRow(label: 'Update terakhir', value: DateFormat('HH:mm, d MMM').format(greenhouse.lastSeen)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SectionHeader(title: 'Sensor live'),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 720 ? 3 : 2;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: demoSensors.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: constraints.maxWidth >= 720 ? 1.45 : .98,
                    ),
                    itemBuilder: (context, index) => SensorCard(
                      reading: greenhouse.deviceOnline ? demoSensors[index] : _stale(demoSensors[index]),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              SectionHeader(
                title: 'Misting',
                action: TextButton.icon(
                  onPressed: () => context.go('/control'),
                  icon: const Icon(LucideIcons.arrowRight, size: 16),
                  label: const Text('Kontrol'),
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  children: [
                    _InfoRow(label: 'Mode', value: misting.isAutomatic ? 'Otomatis • Fuzzy Mamdani' : 'Manual'),
                    _InfoRow(label: 'Pompa', value: misting.pumpOn ? 'ON' : 'OFF'),
                    _InfoRow(label: 'Durasi / interval', value: '${misting.durationSeconds} detik / ${misting.intervalMinutes} menit'),
                    _InfoRow(label: 'Status perintah', value: _commandLabel(misting.commandState)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SectionHeader(
                title: 'Rekomendasi AI',
                action: TextButton.icon(
                  onPressed: () => context.go('/insights'),
                  icon: const Icon(LucideIcons.arrowRight, size: 16),
                  label: const Text('Detail'),
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusBadge(label: latestRecommendation.status, severity: Severity.warning, icon: LucideIcons.sparkles),
                    const SizedBox(height: 12),
                    Text(latestRecommendation.action, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(latestRecommendation.explanation, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SectionHeader(title: 'Peringatan'),
              const SizedBox(height: 12),
              ...demoAlerts.map((alert) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      child: Row(
                        children: [
                            Icon(alert.severity == Severity.warning ? LucideIcons.alertTriangle : LucideIcons.info, color: AppColors.warning),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(alert.title, style: Theme.of(context).textTheme.titleMedium),
                                Text(alert.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  SensorReading _stale(SensorReading reading) => SensorReading(
        label: reading.label,
        value: reading.value,
        unit: reading.unit,
        status: reading.status,
        icon: reading.icon,
        stale: true,
      );

  String _commandLabel(CommandState state) => switch (state) {
        CommandState.pending => 'Pending',
        CommandState.sent => 'Terkirim',
        CommandState.acknowledged => 'Diakui perangkat',
        CommandState.executed => 'Dieksekusi',
        CommandState.failed => 'Gagal',
        CommandState.timedOut => 'Timed out',
        CommandState.rejected => 'Ditolak',
      };
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 132,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText)),
          ),
          Expanded(child: Text(value, textAlign: TextAlign.right, style: Theme.of(context).textTheme.titleMedium)),
        ],
      ),
    );
  }
}
