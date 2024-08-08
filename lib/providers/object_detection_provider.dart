import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/services/object_detection_ml.dart';

//ObjectDetectService objectDetectService = ObjectDetectService();

final objectDetectServiceProvider = Provider((ref) {
  return ObjectDetectService();
});
