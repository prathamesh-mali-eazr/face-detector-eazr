

import 'package:face_detector_eazr/src/core/models/fd_eazr_captured_image.dart';
import 'package:face_detector_eazr/src/core/models/fd_eazr_config.dart';
import 'package:face_detector_eazr/src/core/models/fd_eazr_threshold.dart';
import 'package:face_detector_eazr/src/screens/fd_eazr_screen.dart';
import 'package:flutter/material.dart';

class FaceDetectorEazr {
  //* MARK: - Converting Package to Singleton
  //? =========================================================
  FaceDetectorEazr._privateConstructor();

  static final FaceDetectorEazr instance =
      FaceDetectorEazr._privateConstructor();

  //* MARK: - Private Variables
  //? =========================================================
  final List<FDEazrThreshold> _thresholds = [];

  late EdgeInsets _safeAreaPadding;

  //* MARK: - Public Variables
  //? =========================================================
  List<FDEazrThreshold> get thresholdConfig {
    return _thresholds;
  }

  EdgeInsets get safeAreaPadding {
    return _safeAreaPadding;
  }



 

  Future<FDEazrCapturedImage?> detectLivelyness(
    BuildContext context, {
    required FDEazrConfig config,
  }) async {
    _safeAreaPadding = MediaQuery.of(context).padding;
    final FDEazrCapturedImage? capturedFacePath = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            FDEazrScreen(
          config: config,
        ),
      ),
    );
    return capturedFacePath;
  }

  /// Configures the shreshold values of which will be used while verfying
  /// Parameters: -
  /// * thresholds: - List of [FDEazrThreshold] objects.
  /// * contourColor - Color of the points that are plotted on the face while detecting.
  void configure({
    required List<FDEazrThreshold> thresholds,
    Color lineColor = const Color(0xffab48e0),
    Color dotColor = const Color(0xffab48e0),
    double lineWidth = 1.6,
    double dotSize = 2.0,
    bool displayLines = true,
    bool displayDots = true,
    List<double>? dashValues,
  }) {
    assert(
      thresholds.isNotEmpty,
      "Threshold configuration cannot be empty",
    );
  
    _thresholds.clear();
    _thresholds.addAll(thresholds);
  }
}
