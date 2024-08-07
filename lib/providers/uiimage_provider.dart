import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';

class UiImage extends Notifier<List<ui.Image>> {
  @override
  List<ui.Image> build() {
    return [];
  }

  void addCurrentImage(ui.Image image) {
    state = [...state, image];
    // debugPrint('current page index is $state');
  }

  void clearLst() {
    state = [];
    // debugPrint('current page index is $state');
  }
}
