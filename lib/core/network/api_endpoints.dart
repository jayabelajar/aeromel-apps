abstract final class ApiEndpoints {
  static const apiBasePath = '/api/v1';

  static const login = '$apiBasePath/auth/login';
  static const refresh = '$apiBasePath/auth/refresh';
  static const me = '$apiBasePath/auth/me';
  static const greenhouses = '$apiBasePath/greenhouses';
  static const alerts = '$apiBasePath/alerts';
  static const devices = '$apiBasePath/devices';

  static String greenhouse(String id) => '$greenhouses/$id';
  static String latestTelemetry(String id) =>
      '$greenhouses/$id/telemetry/latest';
  static String telemetryHistory(String id) =>
      '$greenhouses/$id/telemetry/history';
  static String telemetrySummary(String id) =>
      '$greenhouses/$id/telemetry/summary';
  static String actuators(String id) => '$greenhouses/$id/actuators';
  static String mistingConfig(String id) => '$greenhouses/$id/misting/config';
  static String mistingCommand(String id) =>
      '$greenhouses/$id/actuators/misting';
  static String emergencyStop(String id) =>
      '$greenhouses/$id/actuators/emergency-stop';
  static String nutrientAnalyze(String id) =>
      '$greenhouses/$id/nutrients/analyze';
  static String nutrientRecommendations(String id) =>
      '$greenhouses/$id/nutrients/recommendations';
  static String acknowledgeRecommendation(String id) =>
      '$apiBasePath/nutrient-recommendations/$id/acknowledge';
  static String command(String id) => '$apiBasePath/commands/$id';
  static String greenhouseSocket(String id) =>
      '$apiBasePath/ws/greenhouses/$id';
}
