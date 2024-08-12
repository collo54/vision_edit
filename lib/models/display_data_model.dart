import 'latlng_model.dart';
import 'plant_disease_response_model.dart';

class DisplayDataModel {
  final String id;
  final String userId;
  final LatLangModel latlangModel;
  final PlantDiseaseResponseModel plantDiseaseResponse;
  final String? timeStamp;
  final List<String> urls;

  const DisplayDataModel({
    required this.id,
    required this.userId,
    required this.latlangModel,
    required this.plantDiseaseResponse,
    required this.timeStamp,
    required this.urls,
  });

  factory DisplayDataModel.fromJson(Map<String, dynamic> json, String id) {
    return DisplayDataModel(
      id: id,
      userId: json['userId'] ?? '',
      latlangModel: LatLangModel.fromJson(json['latlangModel'] ?? {}),
      plantDiseaseResponse: PlantDiseaseResponseModel.fromJson(
          json['plantDiseaseResponse'] ?? {}),
      timeStamp: json['timeStamp'] ?? '',
      urls: List<String>.from(json['urls'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'latlangModel': latlangModel.toJson(),
      'plantDiseaseResponse': plantDiseaseResponse.toJson(),
      'timeStamp': timeStamp,
      'urls': urls,
    };
  }
}
