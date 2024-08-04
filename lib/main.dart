import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/notebookpainter.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Notebook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MathNotebookPage(),
    );
  }
}

class MathNotebookPage extends ConsumerWidget {
  const MathNotebookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: Container(
              color: Colors.white,
              child: CustomPaint(
                size: const Size(double.infinity, double.infinity),
                painter: NotebookPagePainter(),
              ),
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: size.height / 2,
                width: 100,
                child: ListView.separated(
                  itemCount: 5,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 15,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return FloatingActionButton.small(
                      shape: const CircleBorder(),
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.white,
                      onPressed: () {},
                      child: getIconForNumber(index),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Icon getIconForNumber(int number) {
    switch (number) {
      case 0:
        return const Icon(Icons.camera);
      case 1:
        return const Icon(Icons.record_voice_over);
      case 2:
        return const Icon(Icons.add_a_photo);
      case 3:
        return const Icon(Icons.text_fields);
      case 4:
        return const Icon(Icons.file_copy);
      default:
        return const Icon(Icons.error); // Default icon for numbers outside 0-4
    }
  }
}
