import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsCameraInitialized extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void changeBool(bool isCameraInitialized) {
    state = isCameraInitialized;
    debugPrint('The bool isCameraInitialized is $state');
  }
}