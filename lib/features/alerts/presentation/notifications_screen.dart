import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/models/app_models.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: demoAlerts
            .map(
              (alert) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              alert.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          StatusBadge(
                            label: alert.category,
                            severity: alert.severity,
                            icon: LucideIcons.bell,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        alert.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
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
