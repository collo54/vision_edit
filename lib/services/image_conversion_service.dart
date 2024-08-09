import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

abstract class ConversionService {
  Future<Uint8List> uiImageToImgImageBytes(ui.Image uiImage);
  Uint8List yuv420ToRgba8888Uint8List(
      List<Uint8List> planes, int width, int height);
  Future<ui.Image> cameraImageToUiImage(CameraImage availableImage);
  Future<ui.Image> createUiImageRgba8888(
      Uint8List buffer, int width, int height, ui.PixelFormat pixelFormat);
}

class ImageConversionService extends ConversionService {
  @override
  Future<Uint8List> uiImageToImgImageBytes(ui.Image uiImage) async {
    try {
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

      if (kDebugMode) {
        print('img imageData.Format: ${rotatedImage.format}');
      }
      final uint8list = Uint8List.fromList(img.encodeJpg(
        rotatedImage,
        chroma: img.JpegChroma.yuv420,
      ));

      return uint8list;
    } catch (e) {
      if (kDebugMode) {
        print('error uiImageToImgImageBytes in ImageConversionService: $e');
      }
      throw 'error uiImageToImgImageBytes in ImageConversionService: $e';
    }
  }

  @override
  Uint8List yuv420ToRgba8888Uint8List(
      List<Uint8List> planes, int width, int height) {
    try {
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

          final int r =
              (yValue + 1.13983 * (vValue - 128)).round().clamp(0, 255);
          final int g =
              (yValue - 0.39465 * (uValue - 128) - 0.58060 * (vValue - 128))
                  .round()
                  .clamp(0, 255);
          final int b =
              (yValue + 2.03211 * (uValue - 128)).round().clamp(0, 255);

          final int rgbaIndex = yIndex * 4;
          rgbaBytes[rgbaIndex] = r.toUnsigned(8);
          rgbaBytes[rgbaIndex + 1] = g.toUnsigned(8);
          rgbaBytes[rgbaIndex + 2] = b.toUnsigned(8);
          rgbaBytes[rgbaIndex + 3] = 255; // Alpha value
        }
      }

      return rgbaBytes;
    } catch (e) {
      if (kDebugMode) {
        print('error yuv420ToRgba8888 in ImageConversionService: $e');
      }
      throw 'error yuv420ToRgba8888 in ImageConversionService: $e';
    }
  }

  @override
  Future<ui.Image> cameraImageToUiImage(CameraImage availableImage) async {
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
      Uint8List data =
          yuv420ToRgba8888Uint8List(planes, imageWidth, imageHeight);
      ui.Image imageui = await createUiImageRgba8888(
          data, imageWidth, imageHeight, ui.PixelFormat.rgba8888);

      return imageui;
    } catch (e) {
      if (kDebugMode) {
        print('error cameraImageToUiImage in ImageConversionService: $e');
      }
      throw 'error cameraImageToUiImage in ImageConversionService: $e';
    }
  }

  @override
  Future<ui.Image> createUiImageRgba8888(
      Uint8List buffer, int width, int height, ui.PixelFormat pixelFormat) {
    try {
      final Completer<ui.Image> completer = Completer();

      ui.decodeImageFromPixels(buffer, width, height, pixelFormat,
          (ui.Image img) {
        completer.complete(img);
      });

      return completer.future;
    } catch (e) {
      if (kDebugMode) {
        print('error createUiImageRgba8888 in ImageConversionService: $e');
      }
      throw 'error createUiImageRgba8888 in ImageConversionService: $e';
    }
  }
}
