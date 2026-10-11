import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum Severity { success, warning, danger, info }

enum CommandState {
  pending,
  sent,
  acknowledged,
  executed,
  failed,
  timedOut,
  rejected,
}

class Greenhouse {
  const Greenhouse({
    required this.id,
    required this.name,
    required this.variety,
    required this.stage,
    required this.plantingDate,
    required this.deviceOnline,
    required this.lastSeen,
  });

  final String id;
  final String name;
  final String variety;
  final String stage;
  final DateTime plantingDate;
  final bool deviceOnline;
  final DateTime lastSeen;
}

class SensorReading {
  const SensorReading({
    required this.label,
    required this.value,
    required this.unit,
    required this.status,
    required this.icon,
    this.stale = false,
  });

  final String label;
  final String value;
  final String unit;
  final Severity status;
  final IconData icon;
  final bool stale;
}

class MistingStatus {
  const MistingStatus({
    required this.isAutomatic,
    required this.pumpOn,
    required this.durationSeconds,
    required this.intervalMinutes,
    required this.deviceOnline,
    required this.commandState,
  });

  final bool isAutomatic;
  final bool pumpOn;
  final int durationSeconds;
  final int intervalMinutes;
  final bool deviceOnline;
  final CommandState commandState;
}

class NutrientRecommendation {
  const NutrientRecommendation({
    required this.id,
    required this.status,
    required this.action,
    required this.explanation,
    required this.createdAt,
    required this.acknowledged,
    required this.engineVersion,
  });

  final String id;
  final String status;
  final String action;
  final String explanation;
  final DateTime createdAt;
  final bool acknowledged;
  final String engineVersion;
}

class AlertItem {
  const AlertItem({
    required this.title,
    required this.description,
    required this.category,
    required this.severity,
    required this.createdAt,
  });

  final String title;
  final String description;
  final String category;
  final Severity severity;
  final DateTime createdAt;
}

class MetricPoint {
  const MetricPoint(this.x, this.y);

  final double x;
  final double y;
}

const demoSensors = [
  SensorReading(
    label: 'EC',
    value: '2.15',
    unit: 'mS/cm',
    status: Severity.success,
    icon: LucideIcons.activity,
  ),
  SensorReading(
    label: 'pH',
    value: '6.1',
    unit: '',
    status: Severity.success,
    icon: LucideIcons.flaskConical,
  ),
  SensorReading(
    label: 'Suhu udara',
    value: '28.4',
    unit: '°C',
    status: Severity.warning,
    icon: LucideIcons.thermometer,
  ),
  SensorReading(
    label: 'Kelembapan',
    value: '74',
    unit: '%',
    status: Severity.success,
    icon: LucideIcons.droplets,
  ),
  SensorReading(
    label: 'Suhu air',
    value: '25.2',
    unit: '°C',
    status: Severity.success,
    icon: LucideIcons.waves,
  ),
  SensorReading(
    label: 'Level air',
    value: '38',
    unit: '%',
    status: Severity.warning,
    icon: LucideIcons.gauge,
  ),
];

final demoGreenhouses = [
  Greenhouse(
    id: 'gh-01',
    name: 'Greenhouse A1',
    variety: 'Golden Melon',
    stage: 'Fruiting',
    plantingDate: DateTime(2026, 8, 22),
    deviceOnline: true,
    lastSeen: DateTime(2026, 10, 11, 16, 58),
  ),
  Greenhouse(
    id: 'gh-02',
    name: 'Greenhouse B2',
    variety: 'Honey Globe',
    stage: 'Vegetative',
    plantingDate: DateTime(2026, 9, 9),
    deviceOnline: false,
    lastSeen: DateTime(2026, 10, 11, 13, 12),
  ),
];

final demoMisting = MistingStatus(
  isAutomatic: true,
  pumpOn: false,
  durationSeconds: 18,
  intervalMinutes: 12,
  deviceOnline: true,
  commandState: CommandState.acknowledged,
);

final demoRecommendations = [
  NutrientRecommendation(
    id: 'rec-91',
    status: 'Nutrisi sedikit rendah',
    action: 'Naikkan EC target ke 2.25 mS/cm dan evaluasi pH dalam 2 jam.',
    explanation:
        'EC aktual berada di bawah rentang target fase fruiting, sementara pH masih stabil. Rekomendasi ini hanya panduan operator, bukan perintah dosing otomatis.',
    createdAt: DateTime(2026, 10, 11, 16, 45),
    acknowledged: false,
    engineVersion: 'Rule Engine 1.0',
  ),
  NutrientRecommendation(
    id: 'rec-88',
    status: 'Stabil',
    action: 'Pertahankan komposisi nutrisi saat ini.',
    explanation: 'EC dan pH berada dalam rentang target untuk fase fruiting.',
    createdAt: DateTime(2026, 10, 10, 18, 20),
    acknowledged: true,
    engineVersion: 'Rule Engine 1.0',
  ),
];

final demoAlerts = [
  AlertItem(
    title: 'Level air rendah',
    description: 'Tangki berada di 38%. Isi ulang sebelum misting manual.',
    category: 'Water Level',
    severity: Severity.warning,
    createdAt: DateTime(2026, 10, 11, 16, 35),
  ),
  AlertItem(
    title: 'Suhu udara tinggi',
    description: 'Suhu melewati target selama 12 menit.',
    category: 'Environment',
    severity: Severity.warning,
    createdAt: DateTime(2026, 10, 11, 15, 54),
  ),
];

final ecTrend = List.generate(
  12,
  (i) => MetricPoint(i.toDouble(), 1.9 + (i % 5) * .08),
);
final phTrend = List.generate(
  12,
  (i) => MetricPoint(i.toDouble(), 5.8 + (i % 4) * .12),
);
final tempTrend = List.generate(
  12,
  (i) => MetricPoint(i.toDouble(), 27 + (i % 6) * .6),
);
