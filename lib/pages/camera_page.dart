import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vision_edit/constants/colors.dart';
import 'package:vision_edit/painters/notebookpainter.dart';
import 'package:vision_edit/providers/gemini_provider.dart';
import 'package:vision_edit/providers/image_conversion_provider.dart';
import 'package:vision_edit/widgets/display_camera_images.dart';

import '../providers/camera_provider.dart';
import '../providers/object_detection_provider.dart';
import '../providers/providers.dart';
import '../widgets/list_image_view.dart';

class CameraPage extends ConsumerWidget {
  CameraPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);
    final cameraController = ref.watch(cameraInitializationProvider);
    bool isImageStreamOn = ref.watch(showToastProvider);
    final currentTab = ref.watch(pageIndexProvider);
    List<int> bytesListIndexes = ref.watch(uiImageIndexProvider);
    ref.watch(previousPageIndexProvider);
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
            // Positioned(
            //   top: 0,
            //   child: SizedBox(
            //       height: size.height / 2,
            //       width: size.width,
            //       child: CameraPreview(controller)),
            // ),
            Positioned(
              top: 10,
              child: DisplayCameraImages(
                widget: CameraPreview(controller),
              ),
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                height: size.height / 2 - 40,
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
                  height: 100,
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
                                  // ref
                                  //     .read(imageStreamListenerProvider.notifier)
                                  //     .clearLst();
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
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton.small(
                  shape: const StadiumBorder(),
                  foregroundColor: Colors.black87,
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    final List<Uint8List> bytesListUnfiltered =
                        ref.watch(geminiImageListenerProvider);
                    final bytes = bytesListIndexes.map((index) {
                      return bytesListUnfiltered[index];
                    }).toList();

                    await geminiPrompt(ref, bytes);

                    ref.read(uiImageIndexProvider.notifier).clearIndex();
                  },
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedAiVideo,
                    color: kblack00008,
                    size: 24.0,
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

  Future<dynamic> alertdialog(BuildContext context, String text) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          text,
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
      if (imageNumber % 30 == 0) {
        ref.read(imageFrameProvider.notifier).changeIntTo0();
        final imageConversionService = ref.read(imageConversionServiceProvider);
        Uint8List bytes = cameraImageBytes(image);
        await objectDetect(
          image,
          ref,
          controller,
          option: 0,
          detectmode: 0,
          bytes: bytes,
        );
        // await geminiPrompt(ref, bytes);
        var uiImage = await imageConversionService.cameraImageToUiImage(image);
        var unit8image =
            await imageConversionService.uiImageToImgImageBytes(uiImage);

        debugPrint(image.format.group.name);

        // ref.read(uiImageProvider.notifier).addCurrentImage(uiImage);
        ref
            .read(imageStreamListenerProvider.notifier)
            .addCurrentImage(unit8image);
        ref.read(geminiImageListenerProvider.notifier).addCurrentImage(bytes);
        if (kDebugMode) {
          print(unit8image.length.toString());
        }
      }
    });
  }

  Future<String?> geminiPrompt(WidgetRef ref, List<Uint8List> bytes) async {
    final gemini = ref.watch(geminiProvider);
    gemini.initGeminiModel(
      genmodel: 'gemini-1.5-pro',
    );
    return await gemini.generateText(promptImage: bytes);
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

  HugeIcon getIconForNumber(int number) {
    switch (number) {
      case 0:
        return const HugeIcon(
          icon: HugeIcons.strokeRoundedPlay,
          color: kred236575710,
          size: 24.0,
        );
      case 1:
        return const HugeIcon(
          icon: HugeIcons.strokeRoundedStop,
          color: kblack00008,
          size: 24.0,
        );
      // case 2:
      //   return const Icon(Icons.info);

      default:
        return const HugeIcon(
          icon: HugeIcons.strokeRoundedVideo01,
          color: kblack00008,
          size: 24.0,
        ); // Default icon for numbers outside 0-4
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
    Uint8List bytes,
  ) {
    // Uint8List bytes = cameraImageBytes(image);

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

  Uint8List cameraImageBytes(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    return bytes;
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
    CameraImage image,
    WidgetRef ref,
    CameraController controller, {
    required int option,
    required int detectmode,
    required Uint8List bytes,
  }) async {
    try {
      final objectDetectionservice = ref.read(objectDetectServiceProvider);
      objectDetectionservice.initializeObjectDetector(
        modelPath: 'assets/ml/plants_recognition.tflite',
        option: option,
        detectmode: detectmode,
      );

      final inputImage = _inputImageFromCameraImage(image, controller, bytes);
      if (inputImage == null) {
        if (kDebugMode) {
          print('input image null');
        }
        return;
      }
      final objects = await objectDetectionservice.detectObjects(inputImage);
      if (objects.isEmpty) {
        if (kDebugMode) {
          print('zero objects detected');
        }
        return;
      }
      final dataString =
          'objects: ${objects.map((detObj) => detObj.labels.map((e) => {
                'mlText: ${e.text} , level: ${e.confidence.toString()}, index: ${e.index}, rectBounds: ${detObj.boundingBox.toString()} , trackingId: ${detObj.trackingId} '
              })).toList().toString()}';
      Fluttertoast.showToast(
          msg: "images detected: $dataString",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      if (kDebugMode) {
        print(dataString);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error in object detection: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      if (kDebugMode) {
        print('Error in object detection: $e');
      }
    }
  }
}
