import 'dart:io';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageGalleryHelper {
  static Future<bool> saveToGallery(File image) async {
    // Request permission
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      throw Exception("Gallery permission denied");
    }

    final Uint8List bytes = await image.readAsBytes();

    final result = await ImageGallerySaver.saveImage(
      bytes,
      quality: 100,
      name: "ai_image_${DateTime.now().millisecondsSinceEpoch}",
    );

    return result['isSuccess'] == true;
  }
}
