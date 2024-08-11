import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/providers/providers.dart';
import 'package:vision_edit/widgets/gen_ai_response_widget.dart';
import 'package:vision_edit/widgets/thumbnail_widget.dart';

class ListImageView extends ConsumerWidget {
  final Size size;
  const ListImageView({required this.size, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(uiImageIndexProvider);
    List<Uint8List> imageList = ref.watch(imageStreamListenerProvider);
    if (imageList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView(
          children: const [
            GenAiResponseWidget(
              title: 'Instructions',
              description:
                  'Press play button to capture Image frames.\n Press stop button to stop capturing.\n Select the images needed.\n Ask Gemini with selected Images.\n Read response and opt to save or delete .',
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: GestureDetector(
                onTap: () {
                  ref.read(uiImageIndexProvider.notifier).currentIndex(index);
                },
                child: SizedBox(
                  height: 200,
                  width: size.width / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.memory(imageList[index]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
