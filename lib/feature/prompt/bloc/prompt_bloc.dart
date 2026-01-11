import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/prompt_repo.dart';
import 'prompt_event.dart';
import 'prompt_state.dart';

class PromptBloc extends Bloc<PromptEvent, PromptState> {
  final PromptRepo repo;

  PromptBloc(this.repo) : super(PromptInitial()) {
    on<GenerateTextToImage>(_textToImage);
    on<GenerateImageToVideo>(_imageToVideo);
  }

  Future<void> _textToImage(
      GenerateTextToImage event,
      Emitter<PromptState> emit,
      ) async {
    try {
      emit(PromptLoading());
      final file = await repo.textToImage(event.prompt);
      emit(ImageSuccess(file));
    } catch (_) {
      emit(PromptError("Failed to generate image"));
    }
  }

  Future<void> _imageToVideo(
      GenerateImageToVideo event,
      Emitter<PromptState> emit,
      ) async {
    try {
      emit(PromptLoading());
      final video = await repo.imageToVideo(
        prompt: event.prompt,
        image: event.image,
      );
      emit(VideoSuccess(video));
    } catch (_) {
      emit(PromptError("Failed to generate video"));
    }
  }
}
