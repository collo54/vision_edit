import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UiImageIndex extends Notifier<List<int>> {
  @override
  List<int> build() {
    return [];
  }

  void currentIndex(int index) {
    state = [...state, index];
    debugPrint('ui image list indexes :$state');
  }

  void clearIndex() {
    state = [];
    debugPrint('clear ui Image list Indexes:$state');
  }
}
