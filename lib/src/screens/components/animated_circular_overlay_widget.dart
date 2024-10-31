
import 'package:face_detector_eazr/src/screens/components/radial_gauge/axis/radial_axis.dart';
import 'package:face_detector_eazr/src/screens/components/radial_gauge/gauge/radial_gauge.dart';
import 'package:face_detector_eazr/src/screens/components/radial_gauge/pointers/gauge_pointer.dart';
import 'package:face_detector_eazr/src/screens/components/radial_gauge/pointers/range_pointer.dart';
import 'package:face_detector_eazr/src/screens/components/radial_gauge/styles/radial_tick_style.dart';
import 'package:face_detector_eazr/src/screens/components/radial_gauge/utils/enum.dart';
import 'package:flutter/material.dart';

/// Represents MyHomePage class
class AnimatedCircularOverlayWidget extends StatefulWidget {
  final   double progressValue ;

  const AnimatedCircularOverlayWidget({super.key,  this.progressValue = 0});

  @override
  State<AnimatedCircularOverlayWidget> createState() =>
      _AnimatedCircularOverlayWidgetState();
}

class _AnimatedCircularOverlayWidgetState
    extends State<AnimatedCircularOverlayWidget> {
 

  Widget _getGauge() {
    return _getRadialGauge();
  }

  Widget _getRadialGauge() {
    return SfRadialGauge(
      backgroundColor: Colors.transparent,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          showLabels: false,
          showTicks: false,
          startAngle: 270,
          endAngle: 270,
          radiusFactor: 0.9,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.1,
            color: Colors.transparent,
            // color: Color(0x1E00A9B5),
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: widget.progressValue,
              width: 0.1,
              pointerOffset: 0,
              sizeUnit: GaugeSizeUnit.factor,
              enableAnimation: true,
              animationDuration: 5000,
              animationType: AnimationType.linear,
              // color:const Color(0xFF000303) ,
              color: const Color(0xFF3772FE),
            )
          ],
        ),
        RadialAxis(
            minimum: 0,
            interval: 1,
            maximum: 100,
            showLabels: false,
            showTicks: true,
            showAxisLine: false,
            tickOffset: 0,
            offsetUnit: GaugeSizeUnit.factor,
            minorTicksPerInterval: 0,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.9,
            majorTickStyle: const MajorTickStyle(
              length: 0.1,
              thickness: 5,
              lengthUnit: GaugeSizeUnit.factor,
              color: Color(0xFFfffffb),
              // color: Colors.white,
            ),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getGauge();
  }
}
