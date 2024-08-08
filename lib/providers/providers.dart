import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/providers/showtoast_provider.dart';

import 'image_frame_provider.dart';
import 'imagestream_provider.dart';
import 'initialized_provider.dart';
import 'uiimage_provider.dart';

final isCameraInitializedProvider =
    NotifierProvider<IsCameraInitialized, bool>(IsCameraInitialized.new);

final showToastProvider = NotifierProvider<ShowToast, bool>(ShowToast.new);

final imageStreamListenerProvider =
    NotifierProvider<ImageStreamListener, List<Uint8List>>(
        ImageStreamListener.new);

final imageFrameProvider =
    NotifierProvider<ImageFrameProvider, int>(ImageFrameProvider.new);

final uiImageProvider = NotifierProvider<UiImage, List<ui.Image>>(UiImage.new);
