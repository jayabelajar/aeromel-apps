import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/providers/app_state.dart';

class MistingScreen extends ConsumerStatefulWidget {
  const MistingScreen({super.key});

  @override
  ConsumerState<MistingScreen> createState() => _MistingScreenState();
}

class _MistingScreenState extends ConsumerState<MistingScreen> {
  double _duration = 18;

  Future<void> _confirmStart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mulai misting manual?'),
        content: Text('Perintah akan dikirim selama ${_duration.round()} detik dan menunggu acknowledgement perangkat.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Kirim')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(mistingProvider.notifier).startManual(_duration.round());
    }
  }

  @override
  Widget build(BuildContext context) {
    final misting = ref.watch(mistingProvider);
    final controlDisabled = !misting.deviceOnline;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Smart Misting Control', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 8),
            Text(
              'Kontrol manual selalu menunggu konfirmasi dan acknowledgement perangkat.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.secondaryText),
            ),
            const SizedBox(height: 18),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatusBadge(label: misting.deviceOnline ? 'Device online' : 'Device offline', severity: misting.deviceOnline ? Severity.success : Severity.danger, icon: misting.deviceOnline ? LucideIcons.wifi : LucideIcons.wifiOff),
                      StatusBadge(label: misting.pumpOn ? 'Pompa ON' : 'Pompa OFF', severity: misting.pumpOn ? Severity.warning : Severity.success, icon: LucideIcons.power),
                      StatusBadge(label: _commandLabel(misting.commandState), severity: Severity.info, icon: LucideIcons.radio),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Mode otomatis Fuzzy Mamdani'),
                    subtitle: Text('Durasi ${misting.durationSeconds} detik, interval ${misting.intervalMinutes} menit'),
                    value: misting.isAutomatic,
                    onChanged: controlDisabled ? null : (value) => ref.read(mistingProvider.notifier).toggleMode(value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Manual mode'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Durasi misting', style: Theme.of(context).textTheme.titleMedium),
                  Slider(
                    min: 5,
                    max: 60,
                    divisions: 11,
                    label: '${_duration.round()} detik',
                    value: _duration,
                    onChanged: controlDisabled ? null : (value) => setState(() => _duration = value),
                  ),
                  Text('${_duration.round()} detik', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: controlDisabled ? null : _confirmStart,
                    icon: const Icon(LucideIcons.play),
                    label: const Text('Start misting manual'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Safety controls'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const StatusBadge(label: 'Level air rendah: periksa tangki sebelum manual misting', severity: Severity.warning, icon: LucideIcons.alertTriangle),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: AppColors.danger, minimumSize: const Size.fromHeight(52)),
                    onPressed: controlDisabled ? null : () => ref.read(mistingProvider.notifier).emergencyStop(),
                    icon: const Icon(LucideIcons.xOctagon),
                    label: const Text('Emergency stop'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _commandLabel(CommandState state) => switch (state) {
        CommandState.pending => 'Pending',
        CommandState.sent => 'Sent',
        CommandState.acknowledged => 'Acknowledged',
        CommandState.executed => 'Executed',
        CommandState.failed => 'Failed',
        CommandState.timedOut => 'Timed out',
        CommandState.rejected => 'Rejected',
      };
}
