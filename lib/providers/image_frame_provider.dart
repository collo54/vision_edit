import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageFrameProvider extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void changeInt(int frame) {
    state = (state - state) + frame;
    debugPrint('The image frame is $frame');
  }

  void changeIntTo0() {
    state = state - state;
    debugPrint('The image frame is $state');
  }
}
