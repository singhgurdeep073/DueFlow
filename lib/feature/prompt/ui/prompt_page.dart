import 'package:flutter/material.dart';
import 'taxt_to_image_tab.dart';
import 'image_to_video_tab.dart';

class PromptPage extends StatelessWidget {
  const PromptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1115), // main dark bg
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D24), // tab bg
                borderRadius: BorderRadius.circular(14),
              ),
              child: const TabBar(
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Color(0xFF2D7DFF), // accent blue
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabs: [
                  Tab(text: "Text → Image"),
                  Tab(text: "Image → Video"),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            TextToImageTab(),
            ImageToVideoTab(),
          ],
        ),
      ),
    );
  }
}
