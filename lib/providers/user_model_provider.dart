import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/models/user_model.dart';

class UserModelProviderListener extends Notifier<UserModel> {
  @override
  UserModel build() {
    return UserModel(uid: '', email: '');
  }

  void updateUserModel(UserModel userModel) {
    state = userModel;
    debugPrint('current userModel Uid :${state.uid}');
  }

  void claerUserModel() {
    state = UserModel(uid: '', email: '');
    debugPrint('clear userModel Uid :${state.uid}');
  }
}
