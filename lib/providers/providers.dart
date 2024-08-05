import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'imagestream_provider.dart';
import 'initialized_provider.dart';

final isCameraInitializedProvider =
    NotifierProvider<IsCameraInitialized, bool>(IsCameraInitialized.new);

final imageStreamListenerProvider =
    NotifierProvider<ImageStreamListener, List<Uint8List>>(ImageStreamListener.new);
