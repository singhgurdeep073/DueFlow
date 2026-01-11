import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature/prompt/bloc/prompt_bloc.dart';
import 'feature/prompt/data/prompt_repo.dart';
import 'feature/prompt/ui/taxt_to_image_tab.dart';

void main() {
  const apiKey = "vk-pmrKGMUBdxb5L6XlxM9dYUVTa8bCUQO3E05AOcbDcDc2Db"; // for testing only

  runApp(MyApp(apiKey));
}

class MyApp extends StatelessWidget {
  final String apiKey;
  const MyApp(this.apiKey, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PromptBloc(PromptRepo(apiKey)),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: TextToImageTab(),
      ),
    );
  }
}
