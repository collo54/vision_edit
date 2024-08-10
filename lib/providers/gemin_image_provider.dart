import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeminiImageListener extends Notifier<List<Uint8List>> {
  @override
  List<Uint8List> build() {
    return [];
  }

  void addCurrentImage(Uint8List image) {
    state = [...state, image];
    debugPrint('current gemini Image byte list length: ${state.length}');
  }

  void clearLst() {
    state = [];
    debugPrint('clear gemini Image byte list length: ${state.length}');
  }
}
