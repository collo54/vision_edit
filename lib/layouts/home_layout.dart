import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/widgets/home_data_widget.dart';

import '../providers/display_response_provider.dart';
import '../widgets/gen_ai_response_widget.dart';

class HomeLayout extends ConsumerWidget {
  const HomeLayout({super.key, this.page});
  final int? page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('display home data ****');
    ref.watch(displayresponseStreamProvider);
    final value = ref.watch(displayresponseStreamProvider);
    return value.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text(
            error.toString(),
          ),
        ),
      ),
      data: (displayDataModelList) {
        if (displayDataModelList.isNotEmpty) {
          return ListView.builder(
            itemCount: displayDataModelList.length,
            itemBuilder: (context, index) {
              return HomeDataWidget(
                title: displayDataModelList[index].plantDiseaseResponse.disease,
                description: displayDataModelList[index]
                    .plantDiseaseResponse
                    .causeOfDisease,
                url: displayDataModelList[index].urls.first,
                time: parseTimeHour(displayDataModelList[index].timeStamp!),
                date:
                    parseTimestampDate(displayDataModelList[index].timeStamp!),
                onPressed: () {},
              );
            },
          );
        } else {
          return const Column(
            children: [
              GenAiResponseWidget(
                title: 'Instructions',
                description:
                    'Navigate to the second tab to capture Images to prompt Gemini with.\nSaved responses from Gemini will appear here.',
              ),
            ],
          );
        }
      },
    );
  }

  String parseTimeHour(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String parseTimestampDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return '${dateTime.day} ${getShortMonth(dateTime.month)} ${dateTime.year}';
  }

  String getShortMonth(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
