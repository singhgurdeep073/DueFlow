import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageDownloader {
  static Future<String> saveImage(File image) async {
    // Android 13+ uses photos permission
    final permission = Platform.isAndroid
        ? await Permission.photos.request()
        : await Permission.storage.request();

    if (!permission.isGranted) {
      throw Exception("Storage permission denied");
    }

    final dir = await getExternalStorageDirectory();
    if (dir == null) {
      throw Exception("Storage not available");
    }

    final downloadDir = Directory("${dir.path}/Images");
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    final filePath =
        "${downloadDir.path}/ai_image_${DateTime.now().millisecondsSinceEpoch}.png";

    final savedFile = await image.copy(filePath);
    return savedFile.path;
  }
}
