import 'package:flutter_bloc/flutter_bloc.dart';
import '../Model/generative_image_history.dart';
import '../data/history_storage.dart';
import '../data/prompt_repo.dart';
import 'prompt_event.dart';
import 'prompt_state.dart';

class PromptBloc extends Bloc<PromptEvent, PromptState> {
  final PromptRepo repo;

  List<GeneratedImage> _history = [];

  PromptBloc(this.repo) : super(PromptInitial()) {
    on<GenerateTextToImage>(_textToImage);
    _loadHistory(); // 🔥 load on startup
  }
  void removeHistoryAt(int index) async {
    _history.removeAt(index);
    await HistoryStorage.saveHistory(_history);
  }

  List<GeneratedImage> get history => List.unmodifiable(_history);

  Future<void> _loadHistory() async {
    _history = await HistoryStorage.loadHistory();
  }

  Future<void> _textToImage(
      GenerateTextToImage event,
      Emitter<PromptState> emit,
      ) async {
    try {
      emit(PromptLoading());

      final file = await repo.textToImage(event.prompt);

      // 🔥 add to history
      _history.insert(
        0,
        GeneratedImage(
          imagePath: file.path,
          prompt: event.prompt,
          createdAt: DateTime.now(),
        ),
      );

      // 🔥 persist
      await HistoryStorage.saveHistory(_history);

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
