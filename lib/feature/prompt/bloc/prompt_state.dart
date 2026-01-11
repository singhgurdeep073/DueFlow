import 'dart:io';

abstract class PromptState {}

class PromptInitial extends PromptState {}

class PromptLoading extends PromptState {}

class ImageSuccess extends PromptState {
  final File image;
  ImageSuccess(this.image);
}

class VideoSuccess extends PromptState {
  final File video;
  VideoSuccess(this.video);
}

class PromptError extends PromptState {
  final String message;
  PromptError(this.message);
}
