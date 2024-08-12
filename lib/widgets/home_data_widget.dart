// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vision_edit/constants/colors.dart';

class HomeDataWidget extends ConsumerWidget {
  HomeDataWidget({
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    required this.url,
    required this.onPressed,
    super.key,
  });
  final String title;
  final String date;
  final String time;
  final String description;
  final String url;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: size.width - 40,
          height: 260,
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
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              //  mainAxisAlignment: MainAxisAlignment.start,
              //  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4,
                    right: 4,
                    top: 4,
                    bottom: 4,
                  ),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedImage01,
                            color: kblack00008,
                            size: 24.0,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          date,
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineSmall,
                            fontSize: 16,
                            color: kblack12121210,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const Expanded(
                          child: SizedBox(
                            width: 2,
                          ),
                        ),
                        IconButton(
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedMore01,
                            color: kblack00008,
                            size: 24.0,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4,
                    right: 4,
                    top: 2,
                    bottom: 0,
                  ),
                  child: Text(
                    time,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      fontSize: 16,
                      color: kblack00005,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4,
                    right: 4,
                    top: 2,
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
                    bottom: 4,
                  ),
                  child: SizedBox(
                    height: 50,
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
                ),
                SizedBox(
                  height: 90.0,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(url),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
