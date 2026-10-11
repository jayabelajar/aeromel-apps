import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/token_storage.dart';
import '../models/app_models.dart';

class AppRepository {
  const AppRepository({required this.dioClient, required this.tokenStorage});

  final DioClient? dioClient;
  final TokenStorage tokenStorage;

  bool get _hasApi => dioClient != null;

  Future<void> login(String email, String password) async {
    if (!_hasApi) {
      await _demoDelay();
      await tokenStorage.saveTokens(
        accessToken: 'demo-access-token',
        refreshToken: 'demo-refresh-token',
      );
      return;
    }

    try {
      final response = await dioClient!.dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      final data = response.data ?? const <String, dynamic>{};
      await tokenStorage.saveTokens(
        accessToken: _string(data, ['accessToken', 'access_token', 'token']),
        refreshToken: _string(data, ['refreshToken', 'refresh_token']),
      );
    } on DioException {
      await tokenStorage.saveTokens(
        accessToken: 'demo-access-token',
        refreshToken: 'demo-refresh-token',
      );
    }
  }

  Future<Greenhouse> fetchGreenhouse() async {
    if (!_hasApi) return demoGreenhouses.first;

    try {
      final response = await dioClient!.dio.get(ApiEndpoints.greenhouses);
      return _greenhouseFromJson(_firstItem(response.data));
    } on DioException {
      return demoGreenhouses.first;
    }
  }

  Future<List<SensorReading>> fetchLatestSensors(String greenhouseId) async {
    if (!_hasApi) return demoSensors;

    try {
      final response = await dioClient!.dio.get(
        ApiEndpoints.latestTelemetry(greenhouseId),
      );
      final data = _asMap(response.data);
      final readings = data['sensors'] ?? data['telemetry'] ?? response.data;
      if (readings is List) {
        final parsed = readings
            .whereType<Map>()
            .map((item) => _sensorFromJson(Map<String, dynamic>.from(item)))
            .toList();
        return parsed.isEmpty ? demoSensors : parsed;
      }
      if (readings is Map) {
        final parsed = _sensorListFromTelemetry(
          Map<String, dynamic>.from(readings),
        );
        return parsed.isEmpty ? demoSensors : parsed;
      }
    } on DioException {
      return demoSensors;
    }
    return demoSensors;
  }

  Future<List<NutrientRecommendation>> fetchRecommendations(
    String greenhouseId,
  ) async {
    if (!_hasApi) return demoRecommendations;

    try {
      final response = await dioClient!.dio.get(
        ApiEndpoints.nutrientRecommendations(greenhouseId),
      );
      final parsed = _asList(response.data)
          .whereType<Map>()
          .map(
            (item) => _recommendationFromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
      return parsed.isEmpty ? demoRecommendations : parsed;
    } on DioException {
      return demoRecommendations;
    }
  }

  Future<List<AlertItem>> fetchAlerts() async {
    if (!_hasApi) return demoAlerts;

    try {
      final response = await dioClient!.dio.get(ApiEndpoints.alerts);
      final parsed = _asList(response.data)
          .whereType<Map>()
          .map((item) => _alertFromJson(Map<String, dynamic>.from(item)))
          .toList();
      return parsed.isEmpty ? demoAlerts : parsed;
    } on DioException {
      return demoAlerts;
    }
  }

  Future<void> _demoDelay() =>
      Future<void>.delayed(const Duration(milliseconds: 350));

  static String _string(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return 'demo-token';
  }

  static List<dynamic> _asList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final nested = map['data'] ?? map['items'] ?? map['results'];
      if (nested is List) return nested;
    }
    return const [];
  }

  static Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final nested = map['data'];
      if (nested is Map) return Map<String, dynamic>.from(nested);
      return map;
    }
    return const {};
  }

  static Map<String, dynamic> _firstItem(dynamic data) {
    final list = _asList(data);
    if (list.isNotEmpty && list.first is Map) {
      return Map<String, dynamic>.from(list.first as Map);
    }
    return const {};
  }

  static Greenhouse _greenhouseFromJson(Map<String, dynamic> data) {
    if (data.isEmpty) return demoGreenhouses.first;
    return Greenhouse(
      id: '${data['id'] ?? data['greenhouse_id'] ?? 'gh-01'}',
      name: '${data['name'] ?? data['title'] ?? 'Greenhouse Utama'}',
      variety: '${data['variety'] ?? data['crop_variety'] ?? 'Golden Melon'}',
      stage: '${data['stage'] ?? data['growth_stage'] ?? 'Fruiting'}',
      plantingDate:
          DateTime.tryParse(
            '${data['plantingDate'] ?? data['planting_date']}',
          ) ??
          demoGreenhouses.first.plantingDate,
      deviceOnline:
          data['deviceOnline'] as bool? ?? data['online'] as bool? ?? true,
      lastSeen:
          DateTime.tryParse('${data['lastSeen'] ?? data['last_seen']}') ??
          DateTime.now(),
    );
  }

  static SensorReading _sensorFromJson(Map<String, dynamic> data) {
    final label = '${data['label'] ?? data['name'] ?? 'Sensor'}';
    return SensorReading(
      label: label,
      value: '${data['value'] ?? '-'}',
      unit: '${data['unit'] ?? ''}',
      status: _severity('${data['status'] ?? data['severity'] ?? 'success'}'),
      icon: _iconForLabel(label),
      stale: data['stale'] as bool? ?? false,
    );
  }

  static List<SensorReading> _sensorListFromTelemetry(
    Map<String, dynamic> data,
  ) {
    final mapping = <String, (String, String)>{
      'ec': ('EC', 'mS/cm'),
      'ph': ('pH', ''),
      'air_temperature': ('Suhu udara', '°C'),
      'humidity': ('Kelembapan', '%'),
      'water_temperature': ('Suhu air', '°C'),
      'water_level': ('Level air', '%'),
    };

    return mapping.entries
        .where((entry) => data.containsKey(entry.key))
        .map(
          (entry) => SensorReading(
            label: entry.value.$1,
            value: '${data[entry.key]}',
            unit: entry.value.$2,
            status: Severity.success,
            icon: _iconForLabel(entry.value.$1),
          ),
        )
        .toList();
  }

  static NutrientRecommendation _recommendationFromJson(
    Map<String, dynamic> data,
  ) {
    return NutrientRecommendation(
      id: '${data['id'] ?? 'rec-demo'}',
      status: '${data['status'] ?? 'Stabil'}',
      action: '${data['action'] ?? data['recommendation'] ?? '-'}',
      explanation: '${data['explanation'] ?? data['reason'] ?? '-'}',
      createdAt:
          DateTime.tryParse('${data['createdAt'] ?? data['created_at']}') ??
          DateTime.now(),
      acknowledged: data['acknowledged'] as bool? ?? false,
      engineVersion:
          '${data['engineVersion'] ?? data['engine_version'] ?? 'API'}',
    );
  }

  static AlertItem _alertFromJson(Map<String, dynamic> data) {
    return AlertItem(
      title: '${data['title'] ?? 'Alert'}',
      description: '${data['description'] ?? data['message'] ?? '-'}',
      category: '${data['category'] ?? 'System'}',
      severity: _severity('${data['severity'] ?? 'info'}'),
      createdAt:
          DateTime.tryParse('${data['createdAt'] ?? data['created_at']}') ??
          DateTime.now(),
    );
  }

  static Severity _severity(String value) {
    return switch (value.toLowerCase()) {
      'warning' || 'warn' => Severity.warning,
      'danger' || 'error' || 'critical' => Severity.danger,
      'info' => Severity.info,
      _ => Severity.success,
    };
  }

  static IconData _iconForLabel(String label) {
    final normalized = label.toLowerCase();
    if (normalized.contains('ph')) return LucideIcons.flaskConical;
    if (normalized.contains('suhu') || normalized.contains('temp')) {
      return LucideIcons.thermometer;
    }
    if (normalized.contains('kelembapan') || normalized.contains('humid')) {
      return LucideIcons.droplets;
    }
    if (normalized.contains('level')) return LucideIcons.gauge;
    if (normalized.contains('air')) return LucideIcons.waves;
    return LucideIcons.activity;
  }
}
