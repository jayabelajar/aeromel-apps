import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../shared/models/app_models.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.severity,
    this.icon,
  });

  final String label;
  final Severity severity;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = switch (severity) {
      Severity.success => AppColors.success,
      Severity.warning => AppColors.warning,
      Severity.danger => AppColors.danger,
      Severity.info => AppColors.info,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
