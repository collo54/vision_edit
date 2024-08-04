import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/camera_provider.dart';
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
    final cameraController = ref.watch(cameraInitializationProvider);
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
          // SizedBox(
          //  width: size.width,
          //   height: size.height,
          //   child:
          cameraController.when(
            data: (controller) => CameraPreview(controller),
            error: (error, stackTrace) => Text('Error: $error'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          //  ),
          Positioned(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: size.height / 2,
                width: 100,
                child: ListView.separated(
                  itemCount: 3,
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

      default:
        return const Icon(Icons.error); // Default icon for numbers outside 0-4
    }
  }
}
