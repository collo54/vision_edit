import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/providers/showtoast_provider.dart';

import '../models/plant_disease_response_model.dart';
import '../services/auth_service.dart';
import 'gemin_image_provider.dart';
import 'gemini_image_index_provider.dart';
import 'gemini_response_text_provider.dart';
import 'image_frame_provider.dart';
import 'imagestream_provider.dart';
import 'initialized_provider.dart';
import 'page_index.dart';
import 'previous_page_index.dart';
import 'ui_image_index_provider.dart';
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

final pageIndexProvider = NotifierProvider<PageIndex, int>(PageIndex.new);
final previousPageIndexProvider =
    NotifierProvider<PreviousPageIndex, List<int>>(PreviousPageIndex.new);

final geminiImageIndexProvider =
    NotifierProvider<GeminiImageIndex, List<int>>(GeminiImageIndex.new);
final geminiImageListenerProvider =
    NotifierProvider<GeminiImageListener, List<Uint8List>>(
        GeminiImageListener.new);

final geminiPlantDiseaseResponseModelProvider = NotifierProvider<
        GeminiPlantDiseaseResponseModelNotifier,
        List<PlantDiseaseResponseModel>>(
    GeminiPlantDiseaseResponseModelNotifier.new);

final uiImageIndexProvider =
    NotifierProvider<UiImageIndex, List<int>>(UiImageIndex.new);

/// creates a provider for AuthService class
final authenticate = Provider((ref) => AuthService());


