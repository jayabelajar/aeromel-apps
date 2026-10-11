import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../shared/models/app_models.dart';

class MetricChart extends StatelessWidget {
  const MetricChart({
    super.key,
    required this.points,
    required this.unit,
    required this.color,
  });

  final List<MetricPoint> points;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const SizedBox(
        height: 170,
        child: Center(child: Text('Belum ada data untuk rentang ini.')),
      );
    }

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minX: points.first.x,
          maxX: points.last.x,
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: AppColors.border, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 44,
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(value >= 10 ? 0 : 1),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 3,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}h',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              color: color,
              barWidth: 3,
              isCurved: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: color.withValues(alpha: .12),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (items) => items
                  .map(
                    (item) => LineTooltipItem(
                      '${item.y.toStringAsFixed(2)} $unit',
                      const TextStyle(color: Colors.white),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
