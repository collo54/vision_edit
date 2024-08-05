import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/providers/providers.dart';

class ListImageView extends ConsumerWidget {
  const ListImageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageList = ref.watch(imageStreamListenerProvider);
    if (imageList.isEmpty) {
      return const Center(
        child: Text('No images captured yet'),
      );
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 100,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.memory(imageList[index]),
          ),
        );
      },
    );
  }
}
