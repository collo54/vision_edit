import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/providers/providers.dart';

import 'imagepainter.dart';

class UiImageView extends ConsumerWidget {
  const UiImageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ref.listen(imageStreamListenerProvider, (_, _){});
    List<ui.Image> imageList = ref.watch(uiImageProvider);
    if (imageList.isEmpty) {
      return const Center(
        child: Text('No images captured yet'),
      );
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: SizedBox(
            height: 110,
            width: 110,
            child: FittedBox(
              fit: BoxFit.contain,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CustomPaint(
                  size: const Size(110, 110),
                  painter: ImagePainter(imageList[index]),
                ), // ImagePainter(imageList[index]),
              ),
            ),
          ),
        );
      },
    );
  }
}
