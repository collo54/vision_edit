class PlantDiseaseResponseModel {
  final String plant;
  final String disease;
  final String humanAndLivestockDanger;
  final String causeOfDisease;
  final List<String> preventativeMeasures;

  const PlantDiseaseResponseModel({
    required this.plant,
    required this.disease,
    required this.humanAndLivestockDanger,
    required this.causeOfDisease,
    required this.preventativeMeasures,
  });

  factory PlantDiseaseResponseModel.fromJson(Map<String, dynamic> json) {
    return PlantDiseaseResponseModel(
      plant: json['Plant'] as String,
      disease: json['Disease'] as String,
      humanAndLivestockDanger: json['Human and Livestock Danger'] as String,
      causeOfDisease: json['Cause of Disease'] as String,
      preventativeMeasures:
          List<String>.from(json['Preventative Measures'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Plant'] = plant;
    data['Disease'] = disease;
    data['Human and Livestock Danger'] = humanAndLivestockDanger;
    data['Cause of Disease'] = causeOfDisease;
    data['Preventative Measures'] = preventativeMeasures;
    return data;
  }
}

// {
//   "Plant": "Corn",
//   "Disease": "Aspergillus ear rot",
//   "Human and Livestock Danger": "Aspergillus molds produce mycotoxins that are harmful to both humans and livestock. Consumption of contaminated grain can lead to various health issues like liver damage, reduced immune function, and potentially even cancer.",
//   "Cause of Disease": "Infection occurs during pollination or soon after, particularly when silks remain moist for extended periods due to high humidity or rain.  Wounding of the ear by insects or birds makes infection more likely.",
//   "Preventative Measures": ["Plant resistant corn hybrids if available.", "Ensure proper irrigation to avoid stressing plants, particularly during silking.", "Control insect pests and birds that can damage ears.", "Rotate crops regularly.", "Till under crop residue after harvest to reduce fungal inoculum."]
// }

