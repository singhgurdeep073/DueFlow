import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/feature/prompt/ui/section_card.dart';
import '../bloc/prompt_bloc.dart';
import '../bloc/prompt_event.dart';
import '../bloc/prompt_state.dart';

class ImageToVideoTab extends StatefulWidget {
  const ImageToVideoTab({super.key});

  @override
  State<ImageToVideoTab> createState() => _ImageToVideoTabState();
}

class _ImageToVideoTabState extends State<ImageToVideoTab> {
  File? image;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Image to Video",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          SectionCard(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final picked = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      setState(() => image = File(picked.path));
                    }
                  },
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: image == null
                        ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.upload, size: 32),
                          SizedBox(height: 8),
                          Text("Tap to upload image"),
                        ],
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Describe how the video should look",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.movie),
                    label: const Text("Generate Video"),
                    onPressed: image == null
                        ? null
                        : () {
                      context.read<PromptBloc>().add(
                        GenerateImageToVideo(
                          prompt: controller.text,
                          image: image!,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          BlocBuilder<PromptBloc, PromptState>(
            builder: (context, state) {
              if (state is PromptLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is VideoSuccess) {
                return const SectionCard(
                  child: Text(
                    "🎬 Video generated successfully!",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              }
              if (state is PromptError) {
                return Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
