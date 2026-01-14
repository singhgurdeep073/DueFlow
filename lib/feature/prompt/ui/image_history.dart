import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/prompt_bloc.dart';
import 'gallery_helper.dart';
import 'section_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PromptBloc>();
    final history = bloc.history;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        title: const Text("Generation History"),
        backgroundColor: const Color(0xFF0F1115),
        elevation: 0,
      ),
      body: history.isEmpty
          ? const Center(
        child: Text(
          "No history yet",
          style: TextStyle(color: Colors.white54),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        separatorBuilder: (_, __) =>
        const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = history[index];

          final formattedDate = DateFormat(
            'dd MMM yyyy • hh:mm a',
          ).format(item.createdAt);

          return SectionCard(
            child: ListTile(
              onTap: () {
                _openPreview(context, item);
              },
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  item.image,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                item.prompt,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),maxLines: 4,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  _confirmDelete(context, bloc, index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
  void _openPreview(BuildContext parentContext, dynamic item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F1115),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final formattedDate = DateFormat(
          'dd MMM yyyy • hh:mm a',
        ).format(item.createdAt);

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// DRAG HANDLE
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              /// IMAGE PREVIEW
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  item.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 16),

              /// PROMPT
              Text(
                item.prompt,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              /// DATE
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 20),

              /// DOWNLOAD BUTTON
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.save_alt),
                  label: const Text("Save to Gallery"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await GalleryHelper.saveImage(item.image);

                      Navigator.pop(parentContext); // close bottom sheet first

                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        const SnackBar(
                          content: Text("Image saved to Gallery"),
                        ),
                      );
                    } catch (_) {
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to save image"),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  void _confirmDelete(
      BuildContext context,
      PromptBloc bloc,
      int index,
      ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF141824),
        title: const Text(
          "Remove image?",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "This image will be permanently removed from history.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              bloc.removeHistoryAt(index);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text(
              "Remove",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
