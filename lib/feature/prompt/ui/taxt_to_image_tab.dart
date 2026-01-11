import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/feature/prompt/ui/section_card.dart';
import '../bloc/prompt_bloc.dart';
import '../bloc/prompt_event.dart';
import '../bloc/prompt_state.dart';
import 'image_downloader.dart';
import 'image_gallery_helper.dart';

class TextToImageTab extends StatelessWidget {
  const TextToImageTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0F1115),
        title: const Text(
          "Generative AI Studio",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Text to Image",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// PROMPT CARD
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Prompt",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Describe the image you want to generate",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text("Generate Image"),
                      onPressed: () {
                        context
                            .read<PromptBloc>()
                            .add(GenerateTextToImage(controller.text));
                      },
                    ),
                  ),
                ],
              ),
            ),

            /// RESULT SECTION
            BlocBuilder<PromptBloc, PromptState>(
              builder: (context, state) {
                if (state is PromptLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state is ImageSuccess) {
                  return SectionCard(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(state.image),
                        ),
                        const SizedBox(height: 16),

                        /// DOWNLOAD BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.save_alt),
                            label: const Text("Save to Gallery"),
                            onPressed: () async {
                              try {
                                final success =
                                await ImageGalleryHelper.saveToGallery(state.image);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? "Image saved to Gallery"
                                          : "Failed to save image",
                                    ),
                                  ),
                                );
                              } catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Permission denied"),
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
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
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
