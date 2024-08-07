import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowToast extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void changeBool(bool isCameraInitialized) {
    state = !state;
    debugPrint('The bool isCameraInitialized is $state');
  }
}
