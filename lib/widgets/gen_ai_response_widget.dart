import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vision_edit/constants/colors.dart';

class GenAiResponseWidget extends ConsumerWidget {
  const GenAiResponseWidget({required this.title, required this.description, super.key,});
  final String title;
  final String description;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
        width: size.width - 40,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: kblack00005,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 5,
            left: 5,
            right: 5,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 4,
                  right: 4,
                  top: 4,
                  bottom: 4,
                ),
                child: Text(
                  title, 
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineSmall,
                    fontSize: 16,
                    color: kblack00008,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 4,
                  right: 4,
                  top: 4,
                  bottom: 4,
                ),
                child: Text(
                  description, 
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontSize: 16,
                    color: kblack00005,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
