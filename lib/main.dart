import 'dart:async';
import 'dart:io';
import 'dart:isolate';
//import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:vision_edit/services/object_detection_ml.dart';
import 'dart:ui' as ui;

import 'providers/camera_provider.dart';
import 'providers/object_detection_provider.dart';
import 'providers/providers.dart';
import 'widgets/list_image_view.dart';
import 'painters/notebookpainter.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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

  ui.decodeImageFromPixels(buffer, width, height, pixelFormat, (ui.Image img) {
    completer.complete(img);
  });

  return completer.future;
}

Future<Uint8List> convertFlutterUiToImage(ui.Image uiImage) async {
  // final uiBytes = compute((ByteData? data) async {
  //   if (data == null) {
  //     throw Exception('Failed to convert UI image to ByteData');
  //   }
  //   return data.buffer.asUint8List();
  // }, );

  //    final uiBytes = await uiImage.toByteData();
  // if (uiBytes == null) {
  //   throw Exception('Failed to convert UI image to ByteData');
  // }

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Notebook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MathNotebookPage(),
    );
  }
}

class MathNotebookPage extends ConsumerWidget {
  MathNotebookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);
    final cameraController = ref.watch(cameraInitializationProvider);
    bool isImageStreamOn = ref.watch(showToastProvider);
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
              top: 0,
              child: SizedBox(
                  height: size.height / 2,
                  width: size.width,
                  child: CameraPreview(controller)),
            ),
            Positioned(
              bottom: 10,
              child: SizedBox(
                height: size.height / 2 - 10,
                width: size.width,
                child: ListImageView(
                  size: size,
                ), // UiImageView(),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: size.height / 2,
                  width: 100,
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
                        onPressed: index == 0 && isImageStreamOn == true ||
                                index == 1 && isImageStreamOn == false
                            ? null
                            : () {
                                if (index == 0) {
                                  captureImageStream(controller, ref);
                                } else if (index == 1) {
                                  stopImageStream(controller, ref);
                                  // ref.read(uiImageProvider.notifier).clearLst();
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    ref
                                        .read(imageStreamListenerProvider
                                            .notifier)
                                        .clearLst();
                                  });
                                } else {
                                  bool isImageStreamOnChange = !isImageStreamOn;
                                  ref
                                      .read(showToastProvider.notifier)
                                      .changeBool(isImageStreamOnChange);
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
    bool isImageStreamOn = ref.watch(showToastProvider);
    if (isImageStreamOn == false) {
      ref.read(showToastProvider.notifier).changeBool(true);
    }
    int imageNumber = ref.watch(imageFrameProvider);

    await controller.startImageStream((image) async {
      ref.read(imageFrameProvider.notifier).changeInt(imageNumber + 1);
      if (imageNumber % 20 == 0) {
        ref.read(imageFrameProvider.notifier).changeIntTo0();
        await objectDetect(image, ref, controller);
        // var uiImage = await createImage(image);
        // var unit8image = await convertFlutterUiToImage(uiImage);

        print(image.format.group.name);

        // // ref.read(uiImageProvider.notifier).addCurrentImage(uiImage);
        // ref
        //     .read(imageStreamListenerProvider.notifier)
        //     .addCurrentImage(unit8image);
        // print(unit8image.length.toString());
      }
    });
  }

  FutureOr<void> stopImageStream(
      CameraController controller, WidgetRef ref) async {
    bool isImageStreamOn = ref.watch(showToastProvider);

    if (isImageStreamOn == true) {
      ref.read(showToastProvider.notifier).changeBool(false);
      await controller.stopImageStream();
      disposeObjectDetect(ref);
    }
  }

  void disposeObjectDetect(
    WidgetRef ref,
  ) {
    final objectDetectionservice = ref.watch(objectDetectServiceProvider);
    objectDetectionservice.disposeObjectDetector();
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

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(
    CameraImage image,
    CameraController controller,
  ) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());
    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.nv21;

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: imageSize,
        rotation: InputImageRotation.rotation0deg, // used only in Android
        format: inputImageFormat, // used only in iOS
        bytesPerRow: image.planes[0].bytesPerRow, // used only in iOS
      ),
    );
  }

//   InputImage? _inputImageFromCameraImage(
//     CameraImage image,
//     CameraController controller,
//   ) {
//     final camera = controller.description;
//     final sensorOrientation = camera.sensorOrientation;
//     // print(
//     //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
//     InputImageRotation? rotation;
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       int? rotationCompensation =
//           _orientations[controller.value.deviceOrientation];
//       // if (rotationCompensation == null) return null;
//       if (camera.lensDirection == CameraLensDirection.front) {
//         // front-facing
//         rotationCompensation =
//             (sensorOrientation + rotationCompensation!) % 360;
//       } else {
//         // back-facing
//         rotationCompensation =
//             (sensorOrientation - rotationCompensation! + 360) % 360;
//       }
//       rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
//       // print('rotationCompensation: $rotationCompensation');
//     }
//     // if (rotation == null) return null;
//     // print('final rotation: $rotation');

//     // get image format
//     final format = InputImageFormatValue.fromRawValue(image.format.raw);
//     // validate format depending on platform
//     // only supported formats:
//     // * nv21 for Android
//     // * bgra8888 for iOS
// //     if (format == null ||
// // // Suggested code may be subject to a license. Learn more: ~LicenseLog:1810724695.
// //         (Platform.isAndroid &&
// //             (format != InputImageFormat.nv21 ||
// //                 format != InputImageFormat.yuv420)) ||
// //         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

//     // since format is constraint to nv21 or bgra8888, both only have one plane
//     //  if (image.planes.length != 1) return null;
//     final plane = image.planes.first;

//     // compose InputImage using bytes
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(image.width.toDouble(), image.height.toDouble()),
//         rotation: InputImageRotation.rotation0deg, // used only in Android
//         format: format!, // used only in iOS
//         bytesPerRow: plane.bytesPerRow, // used only in iOS
//       ),
//     );
//   }

  Future<void> objectDetect(
      CameraImage image, WidgetRef ref, CameraController controller) async {
    try {
      final objectDetectionservice = ref.read(objectDetectServiceProvider);
      objectDetectionservice.initializeObjectDetector(
        modelPath: 'assets/ml/food_recognition.tflite',
        option: 0,
        detectmode: 0,
      );

      final inputImage = _inputImageFromCameraImage(image, controller);
      if (inputImage == null) {
        print('input image null');
        return;
      }
      final objects = await objectDetectionservice.detectObjects(inputImage);
      if (objects.isEmpty) {
        print('zero objects detected');
        return;
      }
      final dataString =
          'objects: ${objects.map((e) => e.labels.map((e) => e.text)).toList().toString()}';
      Fluttertoast.showToast(
          msg: "images detected: $dataString",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      print(dataString);
    } catch (e) {
      print('Error in object detection: $e');
    }
  }
}
