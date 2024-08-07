import 'dart:async';
//import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

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
    bool showToast = ref.watch(showToastProvider);
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
                child: ListImageView(), // UiImageView(),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: size.height / 2,
                  width: 170,
                  child: ListView.separated(
                    itemCount: 2,
                    scrollDirection: Axis.horizontal,
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
                            // ref.read(uiImageProvider.notifier).clearLst();
                            ref
                                .read(imageStreamListenerProvider.notifier)
                                .clearLst();
                          } else {
                            bool showToastChange = !showToast;
                            ref
                                .read(showToastProvider.notifier)
                                .changeBool(showToastChange);
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
    await controller.startImageStream((image) async {
      bool showToast = ref.watch(showToastProvider);

      //var unit8image = captureJpeg(image, showToast);
      var uiImage = await createImage(image);
      var unit8image = await convertFlutterUiToImage(uiImage);

      if (showToast) {
        Fluttertoast.showToast(
            msg: "CameraImage format group: ${image.format.group.name}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      print(image.format.group.name);

      // ref.read(uiImageProvider.notifier).addCurrentImage(uiImage);
      ref
          .read(imageStreamListenerProvider.notifier)
          .addCurrentImage(unit8image);
      print(unit8image.length.toString());
    });
  }

  FutureOr<void> stopImageStream(CameraController controller) async {
    await controller.stopImageStream();
  }

  Uint8List captureJpeg(CameraImage image, bool showToast) {
    try {
      final imageData = img.Image.fromBytes(
        width: image.width,
        height: image.height,
        bytes: image.planes.first.bytes.buffer,
        //  bytesOffset: 28, // <---- offset the buffer bytes
        rowStride: image.planes.first.bytesPerRow,
        numChannels: 4,
        order: img.ChannelOrder.bgra,
      );
      // img.Image.fromBytes(
      //   width: image.width,
      //   height: image.height,
      //   bytes: image.planes[0].bytes.buffer,
      //   // order: img.ChannelOrder.bgra,
      //   numChannels: 1,
      // );
      final rotatedImage = img.copyRotate(imageData, angle: 270);

      print('img imageData.Format: ${rotatedImage.format}');
      final jpg = Uint8List.fromList(img.encodeJpg(
        rotatedImage,
        chroma: img.JpegChroma.yuv420,
      ));
      if (showToast) {
        Fluttertoast.showToast(
            msg: "image uint8list length: ${jpg.length}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blueAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      print('image uint8list length: ${jpg.length}');
      return jpg;
    } catch (e) {
      if (showToast) {
        Fluttertoast.showToast(
            msg: "Error capturing image yuv_420_888: $e",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      print('Error capturing image yuv_420_888: $e');
      return Uint8List(0);
    }
  }

  Icon getIconForNumber(int number) {
    switch (number) {
      case 0:
        return const Icon(Icons.play_arrow);
      case 1:
        return const Icon(Icons.stop);
      // case 2:
      //   return const Icon(Icons.info);

      default:
        return const Icon(Icons.error); // Default icon for numbers outside 0-4
    }
  }

  Uint8List yuv420ToRgba8888(List<Uint8List> planes, int width, int height) {
    final yPlane = planes[0];
    final uPlane = planes[1];
    final vPlane = planes[2];

    final Uint8List rgbaBytes = Uint8List(width * height * 4);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int yIndex = y * width + x;
        final int uvIndex = (y ~/ 2) * (width ~/ 2) + (x ~/ 2);

        final int yValue = yPlane[yIndex] & 0xFF;
        final int uValue = uPlane[uvIndex] & 0xFF;
        final int vValue = vPlane[uvIndex] & 0xFF;

        final int r = (yValue + 1.13983 * (vValue - 128)).round().clamp(0, 255);
        final int g =
            (yValue - 0.39465 * (uValue - 128) - 0.58060 * (vValue - 128))
                .round()
                .clamp(0, 255);
        final int b = (yValue + 2.03211 * (uValue - 128)).round().clamp(0, 255);

        final int rgbaIndex = yIndex * 4;
        rgbaBytes[rgbaIndex] = r.toUnsigned(8);
        rgbaBytes[rgbaIndex + 1] = g.toUnsigned(8);
        rgbaBytes[rgbaIndex + 2] = b.toUnsigned(8);
        rgbaBytes[rgbaIndex + 3] = 255; // Alpha value
      }
    }

    return rgbaBytes;
  }

//.PixelFormat
  Future<ui.Image> createImage(CameraImage availableImage) async {
    try {
      int imageWidth = availableImage.width;
      int imageHeight = availableImage.height;
      int imageStride = availableImage.planes[0].bytesPerRow;
      List<Uint8List> planes = [];
      for (int planeIndex = 0; planeIndex < 3; planeIndex++) {
        Uint8List buffer;
        int width;
        int height;
        if (planeIndex == 0) {
          width = availableImage.width;
          height = availableImage.height;
        } else {
          width = availableImage.width ~/ 2;
          height = availableImage.height ~/ 2;
        }

        buffer = Uint8List(width * height);

        int pixelStride = availableImage.planes[planeIndex].bytesPerPixel!;
        int rowStride = availableImage.planes[planeIndex].bytesPerRow;
        int index = 0;
        for (int i = 0; i < height; i++) {
          for (int j = 0; j < width; j++) {
            buffer[index++] = availableImage
                .planes[planeIndex].bytes[i * rowStride + j * pixelStride];
          }
        }

        planes.add(buffer);
      }
      Uint8List data = yuv420ToRgba8888(planes, imageWidth, imageHeight);
      ui.Image imageui = await createImageTest(
          data, imageWidth, imageHeight, ui.PixelFormat.rgba8888);

      return imageui;
    } catch (e) {
      print('error: $e');
      throw e;
    }
  }

  Future<ui.Image> createImageTest(
      Uint8List buffer, int width, int height, ui.PixelFormat pixelFormat) {
    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromPixels(buffer, width, height, pixelFormat,
        (ui.Image img) {
      completer.complete(img);
    });

    return completer.future;
  }

  Future<Uint8List> convertFlutterUiToImage(ui.Image uiImage) async {
    final uiBytes = await uiImage.toByteData();
    if (uiBytes == null) {
      throw Exception('Failed to convert UI image to ByteData');
    }

    final image = img.Image.fromBytes(
      width: uiImage.width,
      height: uiImage.height,
      bytes: uiBytes.buffer,
      numChannels: 4,
    );

    final rotatedImage = img.copyRotate(image, angle: 90);

    print('img imageData.Format: ${rotatedImage.format}');
    final uint8list = Uint8List.fromList(img.encodeJpg(
      rotatedImage,
      chroma: img.JpegChroma.yuv420,
    ));

    return uint8list;
  }
}
