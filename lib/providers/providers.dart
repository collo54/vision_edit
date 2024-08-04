import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/providers/initialized_provider.dart';

final isCameraInitializedProvider =
    NotifierProvider<IsCameraInitialized, bool>(IsCameraInitialized.new);