
import 'package:face_detector_eazr/src/core/models/fd_eazr_step_item.dart';
import 'package:flutter/material.dart';

class FDEazrConfig {
  /// Types of checks to be added while detecting the face.
  final List<FDEazrStepItem> steps;

  /// A boolean value that defines weather the detection should start with a `Info` screen or not.
  /// Default is *false*
  final bool startWithInfoScreen;

  /// Duration in which the face detection should get completed.
  /// Default is *15*
  final int maxSecToDetect;

  /// A boolean value that deinfes whether to allow the user to click the selfie even if the face is not detected.
  final bool allowAfterMaxSec;

  /// Icon color of the button that will come after the [maxSecToDetect] is completed.
  final Color? captureButtonColor;

  FDEazrConfig({
    required this.steps,
    this.startWithInfoScreen = false,
    this.maxSecToDetect = 15,
    this.allowAfterMaxSec = false,
    this.captureButtonColor,
  }) {
    assert(
      steps.isNotEmpty,
      '''
Cannot pass an empty array of [FDEazrStepItem].
      ''',
    );
  }
}
