import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import 'providers.dart';

/// creates a streamProvider to listen to changes in User from firebase auth
/// Can be used to return homepage when user is signed in or login page when user is null
final userProvider = StreamProvider<UserModel?>((ref) async* {
  debugPrint('streamProvider called   ***** ');
  final userDataStream = ref.watch(authenticate).onAuthStateChanged;

  await for (var userData in userDataStream) {
    yield userData;
  }
});
