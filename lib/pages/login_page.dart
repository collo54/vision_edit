import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/layouts/login_layout.dart';

import '../painters/notebookpainter.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          color: Colors.white,
          child: CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: NotebookPagePainter(),
            child: const LoginMobileLayout(),
          ),
        ),
      ),
    );
  }
}
