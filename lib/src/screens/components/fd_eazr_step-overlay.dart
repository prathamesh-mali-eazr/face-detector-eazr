import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:face_detector_eazr/src/core/models/fd_eazr_step_item.dart';
import 'package:face_detector_eazr/src/screens/components/animated_circular_overlay_widget.dart';
import 'package:flutter/material.dart';

class FDEazrStepOverlay extends StatefulWidget {
  final List<FDEazrStepItem> steps;
  final VoidCallback onCompleted;
  const FDEazrStepOverlay({
    super.key,
    required this.steps,
    required this.onCompleted,
  });

  @override
  State<FDEazrStepOverlay> createState() => FDEazrStepOverlayState();
}

class FDEazrStepOverlayState extends State<FDEazrStepOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  //* MARK: - Public Variables
  //? =========================================================
  int get currentIndex {
    return _currentIndex;
  }

  bool _isLoading = false;

  //* MARK: - Private Variables
  //? =========================================================
  int _currentIndex = 0;

  late final PageController _pageController;

  //* MARK: - Life Cycle Methods
  //? =========================================================
  late AudioPlayer _player;

  @override
  void initState() {
    _player = AudioPlayer();
    _player.setSource(
      UrlSource(
        'https://cdn.pixabay.com/download/audio/2021/08/04/audio_96dec480f3.mp3?filename=iphone-camera-capture-6448.mp3',
      ),
    );
    _pageController = PageController(
      initialPage: 0,
    );
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: OverlayWithHolePainter(),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Visibility(
              visible: _isLoading,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: animation,
                builder: (_, __) => AnimatedCircularOverlayWidget(
                  progressValue: animation.value * 100,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                  visible: !_isLoading,
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Please place your face inside\nthe circle and blink.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000303),
                        fontSize: 20
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> startAnimation() async {
    animationController.forward();
    await _player.resume();
  }

  Future<void> nextPage() async {
    if (_isLoading) {
      return;
    }
    if ((_currentIndex + 1) <= (widget.steps.length - 1)) {
      //Move to next step
      _showLoader();
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 0),
        curve: Curves.easeIn,
      );
      _hideLoader();
      setState(() => _currentIndex++);
    } else {
      widget.onCompleted();
    }
  }

  void reset() {
    _pageController.jumpToPage(0);
    setState(() => _currentIndex = 0);
  }

  void _showLoader() => setState(
        () => _isLoading = true,
      );

  void _hideLoader() => setState(
        () => _isLoading = false,
      );
}

class OverlayWithHolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF2B47A6);
    //canvas.drawOval(Rect.fromCircle(center: Offset(size.width /2,size.height/2), radius: size.width /2), paint);

    // canvas.drawCircle(Offset(size.width /2,size.height/2),  size.width /2, paint);

    canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
          Path()
            ..addRRect(RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(size.width / 2, size.height / 2),
                width: size.width * 0.90,
                height: size.width * 0.90,
              ),
              const Radius.circular(200),
            ))
            ..close(),
        ),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

@immutable
class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Alignment? centerAlignment;
  final Offset? centerOffset;
  final double? minRadius;
  final double? maxRadius;

  const CircularRevealClipper({
    required this.fraction,
    this.centerAlignment,
    this.centerOffset,
    this.minRadius,
    this.maxRadius,
  });

  @override
  Path getClip(Size size) {
    final Offset center = centerAlignment?.alongSize(size) ??
        centerOffset ??
        Offset(size.width / 2, size.height / 2);
    final minRadius = this.minRadius ?? 0;
    final maxRadius = this.maxRadius ?? calcMaxRadius(size, center);

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: lerpDouble(minRadius, maxRadius, fraction),
        ),
      );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  static double calcMaxRadius(Size size, Offset center) {
    final w = max(center.dx, size.width - center.dx);
    final h = max(center.dy, size.height - center.dy);
    return sqrt(w * w + h * h);
  }

  static double lerpDouble(double a, double b, double t) {
    return a * (1.0 - t) + b * t;
  }
}

class CircularRevealAnimation extends StatelessWidget {
  final Alignment? centerAlignment;
  final Offset? centerOffset;
  final double? minRadius;
  final double? maxRadius;
  final Widget child;
  final Animation<double> animation;

  /// Creates [CircularRevealAnimation] with given params.
  /// For open animation [animation] should run forward: [AnimationController.forward].
  /// For close animation [animation] should run reverse: [AnimationController.reverse].
  ///
  /// [centerAlignment] center of circular reveal. [centerOffset] if not specified.
  /// [centerOffset] center of circular reveal. Child's center if not specified.
  /// [centerAlignment] or [centerOffset] must be null (or both).
  ///
  /// [minRadius] minimum radius of circular reveal. 0 if not if not specified.
  /// [maxRadius] maximum radius of circular reveal. Distance from center to further child's corner if not specified.
  const CircularRevealAnimation({
    super.key,
    required this.child,
    required this.animation,
    this.centerAlignment,
    this.centerOffset,
    this.minRadius,
    this.maxRadius,
  }) : assert(centerAlignment == null || centerOffset == null);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return ClipPath(
          clipper: CircularRevealClipper(
            fraction: animation.value,
            centerAlignment: centerAlignment,
            centerOffset: centerOffset,
            minRadius: minRadius,
            maxRadius: maxRadius,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
