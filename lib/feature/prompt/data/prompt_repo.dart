import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/network/dio_client.dart';

class PromptRepo {
  final Dio _dio;

  PromptRepo(String apiKey) : _dio = DioClient.create(apiKey);

  /// TEXT → IMAGE
  Future<File> textToImage(String prompt) async {
    final response = await _dio.post(
      "/image/generations",
      data: FormData.fromMap({
        "prompt": prompt,
        "style": "realistic",
        "aspect_ratio": "1:1",
        "seed": "3",
      }),
      options: Options(responseType: ResponseType.bytes),
    );

    final bytes = Uint8List.fromList(response.data);
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/image.png");
    await file.writeAsBytes(bytes);

    return file;
  }

  /// IMAGE → VIDEO
  Future<File> imageToVideo({
    required String prompt,
    required File image,
  }) async {
    final response = await _dio.post(
      "/video/image-to-video",
      data: FormData.fromMap({
        "style": "kling-1.0-pro",
        "prompt": prompt,
        "file": await MultipartFile.fromFile(image.path),
      }),
      options: Options(responseType: ResponseType.bytes),
    );

    final bytes = Uint8List.fromList(response.data);
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/video.mp4");
    await file.writeAsBytes(bytes);

    return file;
  }
}
