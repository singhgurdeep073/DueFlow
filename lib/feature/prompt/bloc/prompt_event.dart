import 'dart:io';

abstract class PromptEvent {}

class GenerateTextToImage extends PromptEvent {
  final String prompt;
  GenerateTextToImage(this.prompt);
}

class GenerateImageToVideo extends PromptEvent {
  final String prompt;
  final File image;

  GenerateImageToVideo({
    required this.prompt,
    required this.image,
  });
}
class ClearHistory extends PromptEvent {}
