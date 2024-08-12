import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/pages/login_page.dart';

import '../providers/providers.dart';
import '../providers/user_login_stream_provider.dart';
import 'home_scaffold.dart';

class AuthState extends ConsumerWidget {
  const AuthState({super.key, this.page});
  final int? page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('authstate called ****');
    ref.watch(userModelProvider);
    final value = ref.watch(userProvider);
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
      data: (user) {
        if (user != null) {
          Future(() {
            ref.read(userModelProvider.notifier).updateUserModel(user);
          });

          return const HomeScaffold();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
