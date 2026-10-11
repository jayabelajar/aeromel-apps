import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/dio_client.dart';
import '../../core/storage/token_storage.dart';
import '../data/app_repository.dart';
import '../models/app_models.dart';

final authProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    repository: ref.watch(appRepositoryProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  ),
);
final activeGreenhouseProvider = StateProvider<Greenhouse?>((ref) => null);
final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => const TokenStorage(),
);
final apiBaseUrlProvider = Provider<String>(
  (ref) => const String.fromEnvironment('AEROMEL_API_BASE_URL'),
);
final dioClientProvider = Provider<DioClient?>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider).trim();
  if (baseUrl.isEmpty) return null;
  return DioClient(
    baseUrl: baseUrl,
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});
final appRepositoryProvider = Provider<AppRepository>(
  (ref) => AppRepository(
    dioClient: ref.watch(dioClientProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  ),
);
final greenhouseProvider = FutureProvider<Greenhouse>((ref) async {
  final active = ref.watch(activeGreenhouseProvider);
  if (active != null) return active;
  final greenhouse = await ref.watch(appRepositoryProvider).fetchGreenhouse();
  ref.read(activeGreenhouseProvider.notifier).state = greenhouse;
  return greenhouse;
});
final sensorsProvider = FutureProvider<List<SensorReading>>((ref) async {
  final greenhouse = await ref.watch(greenhouseProvider.future);
  return ref.watch(appRepositoryProvider).fetchLatestSensors(greenhouse.id);
});
final recommendationsProvider = FutureProvider<List<NutrientRecommendation>>((
  ref,
) async {
  final greenhouse = await ref.watch(greenhouseProvider.future);
  return ref.watch(appRepositoryProvider).fetchRecommendations(greenhouse.id);
});
final alertsProvider = FutureProvider<List<AlertItem>>(
  (ref) => ref.watch(appRepositoryProvider).fetchAlerts(),
);
final mistingProvider = StateNotifierProvider<MistingController, MistingStatus>(
  (ref) => MistingController(),
);
final selectedHistoryRangeProvider = StateProvider<String>((ref) => 'Hari ini');

class AuthController extends StateNotifier<bool> {
  AuthController({required this.repository, required this.tokenStorage})
    : super(false);

  final AppRepository repository;
  final TokenStorage tokenStorage;

  Future<void> login(String email, String password) async {
    if (email.trim().isEmpty || password.trim().length < 6) {
      throw Exception('Email wajib diisi dan password minimal 6 karakter.');
    }
    await repository.login(email.trim(), password);
    state = true;
  }

  Future<void> logout() async {
    await tokenStorage.clear();
    state = false;
  }
}

class MistingController extends StateNotifier<MistingStatus> {
  MistingController() : super(demoMisting);

  void toggleMode(bool automatic) {
    state = MistingStatus(
      isAutomatic: automatic,
      pumpOn: state.pumpOn,
      durationSeconds: state.durationSeconds,
      intervalMinutes: state.intervalMinutes,
      deviceOnline: state.deviceOnline,
      commandState: CommandState.sent,
    );
  }

  Future<void> startManual(int duration) async {
    state = MistingStatus(
      isAutomatic: false,
      pumpOn: true,
      durationSeconds: duration,
      intervalMinutes: state.intervalMinutes,
      deviceOnline: state.deviceOnline,
      commandState: CommandState.pending,
    );
    await Future<void>.delayed(const Duration(milliseconds: 700));
    state = MistingStatus(
      isAutomatic: false,
      pumpOn: true,
      durationSeconds: duration,
      intervalMinutes: state.intervalMinutes,
      deviceOnline: state.deviceOnline,
      commandState: CommandState.acknowledged,
    );
  }

  void emergencyStop() {
    state = MistingStatus(
      isAutomatic: state.isAutomatic,
      pumpOn: false,
      durationSeconds: state.durationSeconds,
      intervalMinutes: state.intervalMinutes,
      deviceOnline: state.deviceOnline,
      commandState: CommandState.executed,
    );
  }
}
