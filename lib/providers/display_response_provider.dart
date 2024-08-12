import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/display_data_model.dart';
import 'providers.dart';

final displayresponseStreamProvider =
    StreamProvider<List<DisplayDataModel>>((ref) {
  debugPrint('streamProvider called   ***** ');
  final userDataStream = ref.watch(cloudFirestoreServiceProvider);

  return userDataStream.displayDataModelStream();
});
