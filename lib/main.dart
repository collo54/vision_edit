import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Notebook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MathNotebookPage(),
    );
  }
}

class MathNotebookPage extends StatelessWidget {
  const MathNotebookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: Container(
              color: Colors.white,
              // Background color like a notebook page
              child:
                  // child: GridView.builder(
                  //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 3, // Two pages side-by-side
                  //   ),
                  //   itemCount: 10, // Adjust the number of pages as needed
                  //   itemBuilder: (context, index) {
                  //     return
                  //  Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.lightBlue, width: 2.0),
                  // ),
                  // margin: const EdgeInsets.all(8.0),
                  // child:
                  CustomPaint(
                size: const Size(double.infinity, double.infinity),
                painter: NotebookPagePainter(),
              ),
              //  ),
              //   },
              // ),
            ),
          ),
          Positioned(
            // bottom: size.height / 2,
            // left: 20,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: size.height / 2,
                width: 100,
                child: ListView.separated(
                  itemCount: 5,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 15,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return FloatingActionButton.small(
                      shape: const CircleBorder(),
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.white,
                      onPressed: () {},
                      child: getIconForNumber(index),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // return Scaffold(
    //   body: SizedBox(
    //     width: size.width,
    //     height: size.height,
    //     child: SingleChildScrollView(
    //       scrollDirection: Axis.horizontal,
    //       child: SizedBox(
    //         width: size.width,
    //         height: size.height,
    //         child: Container(
    //           color: Colors.white, // Background color like a notebook page
    //           child: GridView.builder(
    //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisCount: 3, // Two pages side-by-side
    //             ),
    //             itemCount: 10, // Adjust the number of pages as needed
    //             itemBuilder: (context, index) {
    //               return Container(
    //                 decoration: BoxDecoration(
    //                   border: Border.all(color: Colors.lightBlue, width: 2.0),
    //                 ),
    //                 margin: const EdgeInsets.all(8.0),
    //                 child: CustomPaint(
    //                   size: const Size(double.infinity, double.infinity),
    //                   painter: NotebookPagePainter(),
    //                 ),
    //               );
    //             },
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  Icon getIconForNumber(int number) {
    switch (number) {
      case 0:
        return const Icon(Icons.camera);
      case 1:
        return const Icon(Icons.record_voice_over);
      case 2:
        return const Icon(Icons.add_a_photo);
      case 3:
        return const Icon(Icons.text_fields);
      case 4:
        return const Icon(Icons.file_copy);
      default:
        return const Icon(Icons.error); // Default icon for numbers outside 0-4
    }
  }
}

class NotebookPagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blueGrey[100]! // Light grid lines
      ..strokeWidth = 1.0;

    // Draw vertical lines
    double gridSpacing = 20.0;
    for (double x = gridSpacing; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = gridSpacing; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
