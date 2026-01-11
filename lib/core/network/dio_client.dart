import 'package:dio/dio.dart';

class DioClient {
  static Dio create(String apiKey) {
    return Dio(
      BaseOptions(
        baseUrl: "https://api.vyro.ai/v2",
        headers: {
          "Authorization": "Bearer $apiKey",
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }
}
