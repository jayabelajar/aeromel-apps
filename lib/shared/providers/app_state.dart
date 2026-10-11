import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_models.dart';

final authProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(),
);
final activeGreenhouseProvider = StateProvider<Greenhouse?>((ref) => null);
final mistingProvider = StateNotifierProvider<MistingController, MistingStatus>(
  (ref) => MistingController(),
);
final selectedHistoryRangeProvider = StateProvider<String>((ref) => 'Hari ini');

class AuthController extends StateNotifier<bool> {
  AuthController() : super(false);

  Future<void> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (email.trim().isEmpty || password.trim().length < 6) {
      throw Exception('Email wajib diisi dan password minimal 6 karakter.');
    }
    state = true;
  }

  void logout() => state = false;
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
