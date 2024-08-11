import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/models/plant_disease_response_model.dart';

class GeminiPlantDiseaseResponseModelNotifier extends Notifier<List<PlantDiseaseResponseModel>> {
  @override
  List<PlantDiseaseResponseModel> build() {
    return [];
  }

  void currentIndex(PlantDiseaseResponseModel index) {
    state = [...state, index];
    debugPrint('current PlantDiseaseResponseModel List Indexes:$state');
  }

  void clearIndex() {
    state = [];
    debugPrint('clear PlantDiseaseResponseModel List Indexes:$state');
  }
}
