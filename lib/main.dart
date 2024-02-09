import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'iPhone Slider UI',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
        body: const Center(
          child: SizedBox(
            height: double.maxFinite,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Volume',
                      style:
                          TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                    SliderWidget(icon: Icons.headphones_rounded),
                  ],
                ),
                SizedBox(width: 50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Brightness',
                      style:
                      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                    SliderWidget(icon: Icons.wb_sunny_rounded),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*2nd approach*/
class SliderWidget extends StatefulWidget {
  const SliderWidget({Key? key, required this.icon}) : super(key: key);

  final IconData icon;

  @override
  SliderWidgetState createState() => SliderWidgetState();
}

class SliderWidgetState extends State<SliderWidget> {
  double batteryLevel = 0.0; // Initial battery level
  double additionalHeightTop = 0.0;
  double additionalHeightBottom = 0.0;
  double additionalWidthTop = 0.0;
  double additionalWidthBottom = 0.0;
  Offset offset = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Center(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            // Calculate the new battery level based on the drag position
            double newBatteryLevel = batteryLevel - details.primaryDelta! / 200;

            // Ensure the new battery level stays within the valid range (0.0 to 1.0)
            newBatteryLevel = newBatteryLevel.clamp(0.0, 1.0);

            // Calculate additional height and width when reaching the top
            if (newBatteryLevel == 0.0) {
              additionalHeightTop =
                  (additionalHeightTop + details.primaryDelta! / 10).clamp(0.0, double.infinity);
              additionalWidthTop =
                  (additionalWidthTop - details.primaryDelta! / 60).clamp(0.0, double.infinity);
              offset = const Offset(0, 5);
            } else {
              additionalHeightTop = 5.0;
              additionalWidthTop = 0.0;
            }

            // Calculate additional height and width when reaching the bottom
            if (newBatteryLevel == 1.0) {
              additionalHeightBottom =
                  (additionalHeightBottom + details.primaryDelta! / 10).clamp(0.0, double.infinity);
              additionalWidthBottom =
                  (additionalWidthBottom - details.primaryDelta! / 60).clamp(0.0, double.infinity);
              offset = const Offset(0, -5);
            } else {
              additionalHeightBottom = 5.0;
              additionalWidthBottom = 0.0;
            }

            // Update the state to trigger a rebuild with the new battery level and dimensions
            setState(() => batteryLevel = newBatteryLevel);
          },
          onVerticalDragEnd: (details) {
            // Reset additional dimensions when releasing the drag
            additionalHeightTop = 0.0;
            additionalWidthTop = 0.0;
            additionalHeightBottom = 0.0;
            additionalWidthBottom = 0.0;
            offset = const Offset(0, 0);
          },
          child: Transform.translate(
            offset: offset,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linear,
                    width: 60 - additionalWidthTop - additionalWidthBottom,
                    height: 200 + additionalHeightTop + additionalHeightBottom,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(.3)),
                  ),
                  Positioned(
                    bottom: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.linear,
                      width: 60 - additionalWidthTop - additionalWidthBottom,
                      height: (200 + additionalHeightTop + additionalHeightBottom) * batteryLevel,
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                  ),
                  Positioned(
                    bottom: 14,
                    left: 0,
                    right: 0,
                    child: Icon(
                      widget.icon,
                      color: batteryLevel > 0.05 ? Colors.black54 : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*1st approach*/
//
// class SliderWidget extends StatefulWidget {
//   const SliderWidget({super.key, required this.icon});
//
//   final IconData icon;
//
//   @override
//   SliderWidgetState createState() => SliderWidgetState();
// }
//
// class SliderWidgetState extends State<SliderWidget> {
//   double batteryLevel = 0.1; // Initial battery level
//   double additionalHeightTop = 0.0;
//   double additionalHeightBottom = 0.0;
//   double additionalWidthTop = 0.0;
//   double additionalWidthBottom = 0.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         onVerticalDragUpdate: (details) {
//           // Calculate the new battery level based on the drag position
//           double newBatteryLevel = batteryLevel - details.primaryDelta! / 200;
//
//           // Ensure the new battery level stays within the valid range (0.0 to 1.0)
//           newBatteryLevel = newBatteryLevel.clamp(0.0, 1.0);
//
//           // Calculate additional height and width when reaching the top
//           if (newBatteryLevel == 0.0) {
//             additionalHeightTop += details.primaryDelta! / 10;
//             additionalWidthTop -= details.primaryDelta! / 60;
//           } else {
//             additionalHeightTop = 0.0;
//             additionalWidthTop = 0.0;
//           }
//
//           // Calculate additional height and width when reaching the bottom
//           if (newBatteryLevel == 1.0) {
//             additionalHeightBottom -= details.primaryDelta! / 10;
//             additionalWidthBottom += details.primaryDelta! / 60;
//           } else {
//             additionalHeightBottom = 0.0;
//             additionalWidthBottom = 0.0;
//           }
//
//           // Update the state to trigger a rebuild with the new battery level and dimensions
//           setState(() => batteryLevel = newBatteryLevel);
//         },
//         onVerticalDragEnd: (details) {
//           // Reset additional dimensions when releasing the drag
//           additionalHeightTop = 0.0;
//           additionalWidthTop = 0.0;
//           additionalHeightBottom = 0.0;
//           additionalWidthBottom = 0.0;
//         },
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           child: Stack(
//             children: [
//               Container(
//                 width: 60 - additionalWidthTop - additionalWidthBottom,
//                 height: 200 + additionalHeightTop + additionalHeightBottom,
//                 decoration: BoxDecoration(color: Colors.white.withOpacity(.3)),
//               ),
//               Positioned(
//                 bottom: 0,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeOut,
//                   width: 60 - additionalWidthTop - additionalWidthBottom,
//                   height: (200 + additionalHeightTop + additionalHeightBottom) * batteryLevel,
//                   decoration: const BoxDecoration(color: Colors.white),
//                 ),
//               ),
//               Positioned(
//                 bottom: 14,
//                 left: 0,
//                 right: 0,
//                 child: Icon(
//                   widget.icon,
//                   color: batteryLevel > 0.05 ? Colors.black54 : Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
