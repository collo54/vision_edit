import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vision_edit/constants/colors.dart';
import 'package:vision_edit/widgets/thumbnail_widget.dart';

import '../painters/notebookpainter.dart';
import '../providers/providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    final currentTab = ref.watch(pageIndexProvider);
    ref.watch(previousPageIndexProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kwhite25525525510,
        surfaceTintColor: kwhite25525525510,
        title: Text(
          'Home Page',
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.headlineMedium,
            fontSize: 20,
            color: kblack00008,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          color: Colors.white,
          child: CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: NotebookPagePainter(),
            child: ListView(
              children: [
                ThumbnailWidget(),
                ThumbnailWidget(),
                ThumbnailWidget(),
                ThumbnailWidget(),
                ThumbnailWidget(),
                ThumbnailWidget(),
                ThumbnailWidget(),
                ThumbnailWidget(),
                ThumbnailWidget(),
                ThumbnailWidget(),
                ThumbnailWidget(),
                ThumbnailWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
