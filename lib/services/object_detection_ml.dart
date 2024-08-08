import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:ui' as ui;

abstract class ObjectDetectionMl {
  Future<dynamic> detectObjects(InputImage inputImage);
  void disposeObjectDetector();
  void initializeObjectDetector({
    required String modelPath,
    required int option,
    required int detectmode,
  });
}

class ObjectDetectService extends ObjectDetectionMl {
  late DetectionMode _mode;
  DetectionMode get mode => _mode;

  late ObjectDetector _objectDetector;
  ObjectDetector get objectDetector => _objectDetector;

  final _options = {
    'default': '',
    'object_custom': 'object_labeler.tflite',
    'fruits': 'object_labeler_fruits.tflite',
    'flowers': 'object_labeler_flowers.tflite',
    'birds': 'lite-model_aiy_vision_classifier_birds_V1_3.tflite',
    // https://tfhub.dev/google/lite-model/aiy/vision/classifier/birds_V1/3

    'food': 'lite-model_aiy_vision_classifier_food_V1_1.tflite',
    // https://tfhub.dev/google/lite-model/aiy/vision/classifier/food_V1/1

    'plants': 'lite-model_aiy_vision_classifier_plants_V1_3.tflite',
    // https://tfhub.dev/google/lite-model/aiy/vision/classifier/plants_V1/3

    'mushrooms': 'lite-model_models_mushroom-identification_v1_1.tflite',
    // https://tfhub.dev/bohemian-visual-recognition-alliance/lite-model/models/mushroom-identification_v1/1

    'landmarks':
        'lite-model_on_device_vision_classifier_landmarks_classifier_north_america_V1_1.tflite',
    // https://tfhub.dev/google/lite-model/on_device_vision/classifier/landmarks_classifier_north_america_V1/1
  };

  @override
  Future<List<DetectedObject>> detectObjects(InputImage inputImage) async {
    try {
      List<DetectedObject> objects =
          await _objectDetector.processImage(inputImage);
      return objects;
    } on Exception catch (e) {
      throw Exception('Error in object detection: $e');
    }
  }

  @override
  void disposeObjectDetector() {
    _objectDetector.close();
  }

  @override
  void initializeObjectDetector(
      {required String modelPath,
      required int option,
      required int detectmode}) async {
    try {
      if (detectmode == 0) {
        _mode = DetectionMode.stream;
      } else if (detectmode == 1) {
        _mode = DetectionMode.single;
      }
      if (option == 0) {
        // use the default model
        print('use the default model');
        final options = ObjectDetectorOptions(
          mode: _mode,
          classifyObjects: true,
          multipleObjects: true,
        );
        _objectDetector = ObjectDetector(options: options);
      } else if (option > 0) {
        // use the custom model
        print('use the custom model $modelPath');
        final options = LocalObjectDetectorOptions(
          mode: _mode,
          modelPath: modelPath,
          classifyObjects: true,
          multipleObjects: true,
        );
        _objectDetector = ObjectDetector(options: options);
      }
    } on Exception catch (e) {
      throw Exception('Error initializing object detection: $e');
    }
  }
}
