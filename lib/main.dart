import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'custom/home_scaffold.dart';
import 'pages/camera_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Notebook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const HomeScaffold(),   // CameraPage(),
    );
  }
}

// Uint8List yuv420ToRgba8888(List<Uint8List> planes, int width, int height) {
//   final yPlane = planes[0];
//   final uPlane = planes[1];
//   final vPlane = planes[2];

//   final Uint8List rgbaBytes = Uint8List(width * height * 4);

//   for (int y = 0; y < height; y++) {
//     for (int x = 0; x < width; x++) {
//       final int yIndex = y * width + x;
//       final int uvIndex = (y ~/ 2) * (width ~/ 2) + (x ~/ 2);

//       final int yValue = yPlane[yIndex] & 0xFF;
//       final int uValue = uPlane[uvIndex] & 0xFF;
//       final int vValue = vPlane[uvIndex] & 0xFF;

//       final int r = (yValue + 1.13983 * (vValue - 128)).round().clamp(0, 255);
//       final int g =
//           (yValue - 0.39465 * (uValue - 128) - 0.58060 * (vValue - 128))
//               .round()
//               .clamp(0, 255);
//       final int b = (yValue + 2.03211 * (uValue - 128)).round().clamp(0, 255);

//       final int rgbaIndex = yIndex * 4;
//       rgbaBytes[rgbaIndex] = r.toUnsigned(8);
//       rgbaBytes[rgbaIndex + 1] = g.toUnsigned(8);
//       rgbaBytes[rgbaIndex + 2] = b.toUnsigned(8);
//       rgbaBytes[rgbaIndex + 3] = 255; // Alpha value
//     }
//   }

//   return rgbaBytes;
// }

// //.PixelFormat
// Future<ui.Image> createImage(CameraImage availableImage) async {
//   try {
//     int imageWidth = availableImage.width;
//     int imageHeight = availableImage.height;
//     int imageStride = availableImage.planes[0].bytesPerRow;
//     List<Uint8List> planes = [];
//     for (int planeIndex = 0; planeIndex < 3; planeIndex++) {
//       Uint8List buffer;
//       int width;
//       int height;
//       if (planeIndex == 0) {
//         width = availableImage.width;
//         height = availableImage.height;
//       } else {
//         width = availableImage.width ~/ 2;
//         height = availableImage.height ~/ 2;
//       }

//       buffer = Uint8List(width * height);

//       int pixelStride = availableImage.planes[planeIndex].bytesPerPixel!;
//       int rowStride = availableImage.planes[planeIndex].bytesPerRow;
//       int index = 0;
//       for (int i = 0; i < height; i++) {
//         for (int j = 0; j < width; j++) {
//           buffer[index++] = availableImage
//               .planes[planeIndex].bytes[i * rowStride + j * pixelStride];
//         }
//       }

//       planes.add(buffer);
//     }
//     Uint8List data = yuv420ToRgba8888(planes, imageWidth, imageHeight);
//     ui.Image imageui = await createUiImageRgba8888(
//         data, imageWidth, imageHeight, ui.PixelFormat.rgba8888);

//     return imageui;
//   } catch (e) {
//     if (kDebugMode) {
//       print('error: $e');
//     }
//     rethrow;
//   }
// }

// Future<ui.Image> createUiImageRgba8888(
//     Uint8List buffer, int width, int height, ui.PixelFormat pixelFormat) {
//   final Completer<ui.Image> completer = Completer();

//   ui.decodeImageFromPixels(buffer, width, height, pixelFormat, (ui.Image img) {
//     completer.complete(img);
//   });

//   return completer.future;
// }

// Future<Uint8List> convertFlutterUiToImage(ui.Image uiImage) async {
//   // final uiBytes = compute((ByteData? data) async {
//   //   if (data == null) {
//   //     throw Exception('Failed to convert UI image to ByteData');
//   //   }
//   //   return data.buffer.asUint8List();
//   // }, );

//   //    final uiBytes = await uiImage.toByteData();
//   // if (uiBytes == null) {
//   //   throw Exception('Failed to convert UI image to ByteData');
//   // }

//   final uiBytes = await uiImage.toByteData();

//   if (uiBytes == null) {
//     throw Exception('Failed to convert UI image to ByteData');
//   }

//   final image = img.Image.fromBytes(
//     width: uiImage.width,
//     height: uiImage.height,
//     bytes: uiBytes.buffer,
//     numChannels: 4,
//   );

//   final rotatedImage = img.copyRotate(image, angle: 90);

//   print('img imageData.Format: ${rotatedImage.format}');
//   final uint8list = Uint8List.fromList(img.encodeJpg(
//     rotatedImage,
//     chroma: img.JpegChroma.yuv420,
//   ));

//   return uint8list;
// }


