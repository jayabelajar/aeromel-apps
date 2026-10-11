import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../shared/models/app_models.dart';
import 'app_card.dart';
import 'status_badge.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({super.key, required this.reading});

  final SensorReading reading;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(reading.icon, color: AppColors.primaryGreen, size: 19),
              ),
              const Spacer(),
              if (reading.stale) const StatusBadge(label: 'Cached', severity: Severity.warning),
            ],
          ),
          const SizedBox(height: 16),
          Text(reading.label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryText)),
          const SizedBox(height: 6),
          FittedBox(
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(reading.value, style: Theme.of(context).textTheme.displaySmall),
                if (reading.unit.isNotEmpty) ...[
                  const SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(reading.unit, style: Theme.of(context).textTheme.labelMedium),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
