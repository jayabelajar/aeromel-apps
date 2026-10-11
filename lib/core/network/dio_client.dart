import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

class DioClient {
  DioClient({
    required this.baseUrl,
    required this.tokenStorage,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    )..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = await tokenStorage.readAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            handler.next(options);
          },
        ),
      );
  }

  final String baseUrl;
  final TokenStorage tokenStorage;
  late final Dio dio;
}
