import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/providers/providers.dart';
import 'package:vision_edit/widgets/display_camera_images.dart';
import 'package:vision_edit/widgets/gen_ai_response_widget.dart';
import 'package:vision_edit/widgets/plant_widget.dart';

import '../models/plant_disease_response_model.dart';

class DisplayGeminiResponseView extends ConsumerWidget {
  final Size size;
  const DisplayGeminiResponseView({required this.size, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(uiImageIndexProvider);
    List<PlantDiseaseResponseModel> geminiResponseDataList =
        ref.watch(geminiPlantDiseaseResponseModelProvider);
    if (geminiResponseDataList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView(
          children: [
            DisplayCameraImages(
              widget: Text('No data received'),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView(
          children: [
            PlantResponseWidget(
              title: geminiResponseDataList.last.plant,
            ),
            GenAiResponseWidget(
              title: geminiResponseDataList.last.disease,
              description: geminiResponseDataList.last.causeOfDisease,
            ),
            GenAiResponseWidget(
              title: 'Human and Livestock Danger',
              description: geminiResponseDataList.last.humanAndLivestockDanger,
            ),
            geminiResponseDataList.last.preventativeMeasures.isEmpty
                ? const SizedBox()
                : GenAiResponseWidget(
                    title: 'Prevention',
                    description: geminiResponseDataList
                        .last.preventativeMeasures
                        .map((e) => '$e\n')
                        .toString(),
                  ),
            geminiResponseDataList.last.treatment.isEmpty
                ? const SizedBox()
                : GenAiResponseWidget(
                    title: 'Treatment',
                    description: geminiResponseDataList.last.treatment
                        .map((e) => '$e\n')
                        .toString(),
                  ),
          ],
        ),
      );
    }
  }
}
