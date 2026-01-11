import 'dart:io';
import 'package:gal/gal.dart';

class GalleryHelper {
  static Future<void> saveImage(File image) async {
    await Gal.putImage(image.path);
  }
}
