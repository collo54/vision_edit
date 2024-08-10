import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeminiImageIndex extends Notifier<List<int>> {
  @override
  List<int> build() {
    return [];
  }

  void currentIndex(int index) {
    state = [...state, index];
    debugPrint('current gemini Image List Indexes:$state');
  }

  void clearIndex() {
    state = [];
    debugPrint('clear gemini Image List Indexes:$state');
  }
}
