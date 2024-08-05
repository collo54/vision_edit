import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageStreamListener extends Notifier<List<Uint8List>> {
  @override
  List<Uint8List> build() {
    return [];
  }

  void addCurrentImage(Uint8List image) {
    state = [...state, image];
    // debugPrint('current page index is $state');
  }

  void clearLst() {
    state = [];
    // debugPrint('current page index is $state');
  }
}
