import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/feature/prompt/ui/section_card.dart';
import '../bloc/prompt_bloc.dart';
import '../bloc/prompt_event.dart';
import '../bloc/prompt_state.dart';
import 'gallery_helper.dart';
import 'image_history.dart';

class TextToImageTab extends StatefulWidget {
  const TextToImageTab({super.key});

  @override
  State<TextToImageTab> createState() => _TextToImageTabState();
}

class _TextToImageTabState extends State<TextToImageTab> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
    context.select((PromptBloc bloc) => bloc.state is PromptLoading);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar( elevation: 0,
        backgroundColor: const Color(0xFF0F1115),
        title: const Text( "Generative AI Studio",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryPage(),
                ),
              );
            },
          ),
        ],

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            const Text(
              "Text → Image",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Describe what you want to generate",
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 20),

            /// PROMPT INPUT
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Prompt",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "A futuristic city at night with neon lights...",
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF141824),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  /// GENERATE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor:
                        isLoading ? Colors.blueGrey : const Color(0xFF2D7DFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                        // 1️⃣ READ TEXT FIRST
                        final text = controller.text.trim();

                        // 2️⃣ VALIDATE
                        if (text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                              Text("Please enter a prompt first"),
                            ),
                          );
                          return;
                        }

                        // 3️⃣ DISPATCH EVENT (SYNC – CORRECT)
                        context
                            .read<PromptBloc>()
                            .add(GenerateTextToImage(text));
                      },
                      child: isLoading
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        "Generate Image",
                        style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// RESULT
            BlocBuilder<PromptBloc, PromptState>(
              builder: (context, state) {
                if (state is ImageSuccess) {
                  return SectionCard(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            state.image,
                            key: ValueKey(state.image.path),
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Colors.white24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.save_alt),
                            label: const Text("Save to Gallery"),
                            onPressed: () async {
                              try {
                                await GalleryHelper.saveImage(state.image);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                    Text("Image saved to Gallery"),
                                  ),
                                );
                              } catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                    Text("Failed to save image"),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is PromptError) {
                  return Text(
                    state.message,
                    style: const TextStyle(color: Colors.redAccent),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
