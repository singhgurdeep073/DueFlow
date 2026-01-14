import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/generative_image_history.dart';

class HistoryStorage {
  static const _key = 'image_history';

  /// Load history
  static Future<List<GeneratedImage>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];

    return raw
        .map((e) => GeneratedImage.fromMap(jsonDecode(e)))
        .toList();
  }
  static Future<void> removeAt(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];

    if (index >= 0 && index < raw.length) {
      raw.removeAt(index);
      await prefs.setStringList(_key, raw);
    }
  }

  /// Save history
  static Future<void> saveHistory(
      List<GeneratedImage> history,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
    history.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(_key, encoded);
  }
}
