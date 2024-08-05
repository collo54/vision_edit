import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/providers/providers.dart';

class ListImageView extends ConsumerWidget {
  const ListImageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ref.listen(imageStreamListenerProvider, (_, _){});
    List<Uint8List> imageList = ref.watch(imageStreamListenerProvider);
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
            height: 130,
            width: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.memory(imageList[index]),
            ),
          ),
        );
      },
    );
  }
}
