import 'dart:async';
//import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;

import 'providers/camera_provider.dart';
import 'providers/providers.dart';
import 'widgets/list_image_view.dart';
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
      body: cameraController.when(
        data: (controller) => Stack(
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
              top: 10,
              child: SizedBox(
                  height: size.height / 2,
                  width: size.width,
                  child: CameraPreview(controller)),
            ),
            Positioned(
              bottom: 10,
              child: SizedBox(
                  height: size.height / 2,
                  width: size.width,
                  child: ListImageView(),),
            ),
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
                      height: 12,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return FloatingActionButton.small(
                        shape: const CircleBorder(),
                        foregroundColor: Colors.black87,
                        backgroundColor: Colors.white,
                        onPressed: () {
                          if (index == 0) {
                            captureImageStream(controller, ref);
                          } else if (index == 1) {
                            stopImageStream(controller);
                          } else {
                            ref
                                .read(imageStreamListenerProvider.notifier)
                                .clearLst();
                          }
                        },
                        child: getIconForNumber(index),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> captureImageStream(
      CameraController controller, WidgetRef ref) async {
    await controller.startImageStream((image) {
      var unit8image = captureJpeg(image);
      // var unit8image = jpegConv(image);
      ref
          .read(imageStreamListenerProvider.notifier)
          .addCurrentImage(unit8image);
      print(unit8image.length.toString());
      print('hurayyyyyyyyyyyyyyy');
    });
  }

  FutureOr<void> stopImageStream(CameraController controller) async {
    await controller.stopImageStream();
  }

  Uint8List jpegConv(CameraImage image) {
    try {
      final imageData = img.decodeImage(image.planes[0].bytes);
      if (imageData == null) {
        Fluttertoast.showToast(
            msg: "error decoding image",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        print('Error decoding image');
        return Uint8List(0);
      }
      final jpeg = Uint8List.fromList(img.encodeJpg(imageData));
      Fluttertoast.showToast(
          msg: "jpeg data coool: ${jpeg.length}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      print('jpeg data coool: ${jpeg.length}');
      return jpeg;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error capturing image 2222: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print('Error capturing image 2222: $e');
      return Uint8List(0);
    }
  }

  Uint8List captureJpeg(CameraImage image) {
    try {
      final imageData = img.Image.fromBytes(
        width: image.width,
        height: image.height,
        bytes: image.planes[0].bytes.buffer,
        order: img.ChannelOrder.bgra,
        numChannels: 1,
      );

      Fluttertoast.showToast(
          msg: "img image is data: ${imageData.format}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      print('img image is data: ${imageData.format}');
      final jpeg = Uint8List.fromList(
          img.encodeJpg(imageData)); //img.encodeJpg(imageData);
      Fluttertoast.showToast(
          msg: "jpeg data: ${jpeg.length}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      print('jpeg data: ${jpeg.length}');
      return jpeg;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error capturing image 88888888: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print('Error capturing image 88888888: $e');
      return Uint8List(0);
    }
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
