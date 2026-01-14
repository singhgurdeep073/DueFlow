import 'dart:io';

class GeneratedImage {
  final String imagePath;
  final String prompt;
  final DateTime createdAt;

  GeneratedImage({
    required this.imagePath,
    required this.prompt,
    required this.createdAt,
  });

  File get image => File(imagePath);

  // 🔹 Convert to Map for SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'prompt': prompt,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // 🔹 Create from Map
  factory GeneratedImage.fromMap(Map<String, dynamic> map) {
    return GeneratedImage(
      imagePath: map['imagePath'],
      prompt: map['prompt'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
