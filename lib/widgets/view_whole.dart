import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/constants/colors.dart';
import 'package:vision_edit/widgets/gen_ai_response_widget.dart';
import 'package:vision_edit/widgets/plant_widget.dart';

import '../models/display_data_model.dart';

class ViewWholeResponseWidget extends ConsumerWidget {
  const ViewWholeResponseWidget({
    required this.size,
    required this.dataModel,
    super.key,
  });
  final DisplayDataModel dataModel;
  final Size size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: ListView(
        children: [
          PlantResponseWidget(
            title: dataModel.plantDiseaseResponse.plant,
          ),
          GenAiResponseWidget(
            title: dataModel.plantDiseaseResponse.disease,
            description: dataModel.plantDiseaseResponse.causeOfDisease,
          ),
          GenAiResponseWidget(
            title: 'Human and Livestock Danger',
            description: dataModel.plantDiseaseResponse.humanAndLivestockDanger,
          ),
          dataModel.plantDiseaseResponse.preventativeMeasures.isEmpty
              ? const SizedBox()
              : GenAiResponseWidget(
                  title: 'Prevention',
                  description: dataModel
                      .plantDiseaseResponse.preventativeMeasures
                      .map((e) => '$e\n')
                      .toString(),
                ),
          dataModel.plantDiseaseResponse.treatment.isEmpty
              ? const SizedBox()
              : GenAiResponseWidget(
                  title: 'Treatment',
                  description: dataModel.plantDiseaseResponse.treatment
                      .map((e) => '$e\n')
                      .toString(),
                ),
          SizedBox(
            height: 250,
            width: size.width - 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dataModel.urls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Container(
                    height: 200,
                    width: size.width / 3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: kblack00005,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        dataModel.urls[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
