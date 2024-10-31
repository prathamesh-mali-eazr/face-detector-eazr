
import 'package:face_detector_eazr/src/screens/components/radial_gauge/axis/radial_axis.dart';
import 'package:face_detector_eazr/src/screens/components/radial_gauge/gauge/radial_gauge_scope.dart';
import 'package:flutter/material.dart';


class SfRadialGauge extends StatefulWidget {

  SfRadialGauge({
    super.key,
    List<RadialAxis>? axes,
    this.enableLoadingAnimation = false,
    this.animationDuration = 2000,
    this.backgroundColor = Colors.transparent,
  })  : axes = axes ?? <RadialAxis>[RadialAxis()];

  final List<RadialAxis> axes;


  final bool enableLoadingAnimation;
  final double animationDuration;

  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() {
    return SfRadialGaugeState();
  }
}

class SfRadialGaugeState extends State<SfRadialGauge>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    final List<Widget> radialAxes = <Widget>[];

    for (int i = 0; i < widget.axes.length; i++) {
      radialAxes.add(RadialGaugeScope(
          enableLoadingAnimation: widget.enableLoadingAnimation,
          animationDuration: widget.animationDuration.toInt(),
          child: widget.axes[i]));
    }

    return Stack(
      textDirection: TextDirection.ltr,
      children: radialAxes,
    );
  }

  // Future<dart_ui.Image> toImage({double pixelRatio = 1.0}) async {
  //   final RenderRepaintBoundary? boundary =
  //       context.findRenderObject() as RenderRepaintBoundary?;
  //   final dart_ui.Image image = await boundary!.toImage(pixelRatio: pixelRatio);
  //   return image;
  // }
}
