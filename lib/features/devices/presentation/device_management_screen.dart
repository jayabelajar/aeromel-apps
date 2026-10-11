import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/models/app_models.dart';

class DeviceManagementScreen extends StatelessWidget {
  const DeviceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Management')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: demoGreenhouses
            .map(
              (greenhouse) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.cpu, color: AppColors.primaryGreen),
                          const SizedBox(width: 12),
                          Expanded(child: Text('ESP32-${greenhouse.id.toUpperCase()}', style: Theme.of(context).textTheme.titleLarge)),
                          StatusBadge(
                            label: greenhouse.deviceOnline ? 'Online' : 'Offline',
                            severity: greenhouse.deviceOnline ? Severity.success : Severity.danger,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text('Assigned: ${greenhouse.name}', style: Theme.of(context).textTheme.bodyMedium),
                      Text('Firmware: 1.4.2 • Sensor: EC, pH, DHT, Water Level', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText)),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
