import 'dart:async';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:face_detector_eazr/src/core/enums/fd_eazr_steps.dart';
import 'package:face_detector_eazr/src/core/extensions/ml_kit_extension.dart';
import 'package:face_detector_eazr/src/core/helpers/utils.dart';
import 'package:face_detector_eazr/src/core/models/face_detection_model.dart';
import 'package:face_detector_eazr/src/core/models/fd_eazr_captured_image.dart';
import 'package:face_detector_eazr/src/core/models/fd_eazr_config.dart';
import 'package:face_detector_eazr/src/core/models/fd_eazr_step_item.dart';
import 'package:face_detector_eazr/src/screens/components/fd_eazr_decorator_widget.dart';
import 'package:face_detector_eazr/src/screens/components/fd_eazr_step-overlay.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';


// class FDEazrScreen extends StatelessWidget {
//   final FDEazrConfig config;

//   const FDEazrScreen({
//     required this.config,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: FDEazrLivelynessDetectionScreenV2(
//           config: config,
//         ),
//       ),
//     );
//   }
// }

class FDEazrScreen extends StatefulWidget {
  final FDEazrConfig config;

  const FDEazrScreen({
    required this.config,
    super.key,
  });


  @override
  State<FDEazrScreen> createState() =>
      _FDEazrLivelynessDetectionScreenAndroidState();
}

class _FDEazrLivelynessDetectionScreenAndroidState
    extends State<FDEazrScreen> {
  //* MARK: - Private Variables
  //? =========================================================
  final _faceDetectionController = BehaviorSubject<FaceDetectionModel>();

  final options = FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
    enableTracking: true,
    enableLandmarks: true,
    performanceMode: FaceDetectorMode.accurate,
    minFaceSize: 0.05,
  );
  late final faceDetector = FaceDetector(options: options);
  bool _didCloseEyes = false;
  bool _isProcessingStep = false;

  late final List<FDEazrStepItem> _steps;
  final GlobalKey<FDEazrStepOverlayState> _stepsKey =
      GlobalKey<FDEazrStepOverlayState>();

  CameraState? _cameraState;
  bool _isProcessing = false;
  Timer? _timerToDetectFace;
  bool _isCompleted = false;

  //* MARK: - Life Cycle Methods
  //? =========================================================
  @override
  void initState() {
    _preInitCallBack();
    super.initState();
  
  }

  @override
  void deactivate() {
    faceDetector.close();
    super.deactivate();
  }

  @override
  void dispose() {
    _faceDetectionController.close();
    _timerToDetectFace?.cancel();
    _timerToDetectFace = null;
    super.dispose();
  }

  //* MARK: - Private Methods for Business Logic
  //? =========================================================
  void _preInitCallBack() {
    _steps = widget.config.steps;
  }

  
  Future<void> _processCameraImage(AnalysisImage img) async {
    if (_isProcessing) {
      return;
    }
    if (mounted) {
      setState(
        () => _isProcessing = true,
      );
    }
    final inputImage = img.toInputImage();

    try {
      final List<Face> detectedFaces =
          await faceDetector.processImage(inputImage);
      _faceDetectionController.add(
        FaceDetectionModel(
          faces: detectedFaces,
          absoluteImageSize: inputImage.inputImageData!.size,
          rotation: 0,
          imageRotation: img.inputImageRotation,
          croppedSize: img.croppedSize,
        ),
      );
      await _processImage(inputImage, detectedFaces);
      if (mounted) {
        setState(
          () => _isProcessing = false,
        );
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _isProcessing = false,
        );
      }
      debugPrint("...sending image resulted error $error");
    }
  }

  Future<void> _processImage(InputImage img, List<Face> faces) async {
    try {
      if (faces.isEmpty) {
        _resetSteps();
        return;
      }
      final Face firstFace = faces.first;
      if (_isProcessingStep &&
          _steps[_stepsKey.currentState?.currentIndex ?? 0].step ==
              FDEazrSteps.blink) {
        if (_didCloseEyes) {
          if ((faces.first.leftEyeOpenProbability ?? 1.0) < 0.75 &&
              (faces.first.rightEyeOpenProbability ?? 1.0) < 0.75) {
            await _completeStep(
              step: _steps[_stepsKey.currentState?.currentIndex ?? 0].step,
            );
          }
        }
      }
      _detect(
        face: firstFace,
        step: _steps[_stepsKey.currentState?.currentIndex ?? 0].step,
      );
    } catch (e) {
      _startProcessing();
    }
  }

  Future<void> _completeStep({
    required FDEazrSteps step,
  }) async {
    final int indexToUpdate = _steps.indexWhere(
      (p0) => p0.step == step,
    );

    _steps[indexToUpdate] = _steps[indexToUpdate].copyWith(
      isCompleted: true,
    );
    if (mounted) {
      setState(() {});
    }
    _stepsKey.currentState?.nextPage();
   await _stepsKey.currentState?.startAnimation();
    _stopProcessing();
  }

  void _detect({
    required Face face,
    required FDEazrSteps step,
  }) async {
    switch (step) {
      case FDEazrSteps.blink:
        const double blinkThreshold = 0.25;
        if ((face.leftEyeOpenProbability ?? 1.0) < (blinkThreshold) &&
            (face.rightEyeOpenProbability ?? 1.0) < (blinkThreshold)) {
          _startProcessing();
          if (mounted) {
            setState(
              () => _didCloseEyes = true,
            );
          }
        }
        break;
      case FDEazrSteps.turnLeft:
        const double headTurnThreshold = 45.0;
        if ((face.headEulerAngleY ?? 0) > (headTurnThreshold)) {
          _startProcessing();
          await _completeStep(step: step);
        }
        break;
      case FDEazrSteps.turnRight:
        const double headTurnThreshold = -50.0;
        if ((face.headEulerAngleY ?? 0) > (headTurnThreshold)) {
          _startProcessing();
          await _completeStep(step: step);
        }
        break;
      case FDEazrSteps.smile:
        const double smileThreshold = 0.75;
        if ((face.smilingProbability ?? 0) > (smileThreshold)) {
          _startProcessing();
          await _completeStep(step: step);
        }
        break;
    }
  }

  void _startProcessing() {
    if (!mounted) {
      return;
    }
    setState(
      () => _isProcessingStep = true,
    );
  }

  void _stopProcessing() {
    if (!mounted) {
      return;
    }
    setState(
      () => _isProcessingStep = false,
    );
  }

 

  Future<void> _takePicture({
    required bool didCaptureAutomatically,
  }) async {
    if (_cameraState == null) {
      _onDetectionCompleted();
      return;
    }
    _cameraState?.when(
      onPhotoMode: (p0) => Future.delayed(
        const Duration(milliseconds: 500),
        () => p0.takePhoto().then(
          (value) {
            _onDetectionCompleted(
              imgToReturn: value,
              didCaptureAutomatically: didCaptureAutomatically,
            );
          },
        ),
      ),
    );
  }

  void _onDetectionCompleted({
    String? imgToReturn,
    bool? didCaptureAutomatically,
  }) {
    if (_isCompleted) {
      return;
    }
    setState(
      () => _isCompleted = true,
    );
    final String imgPath = imgToReturn ?? "";
    if (imgPath.isEmpty || didCaptureAutomatically == null) {
      Navigator.of(context).pop(null);
      return;
    }
    Navigator.of(context).pop(
      FDEazrCapturedImage(
        imgPath: imgPath,
        didCaptureAutomatically: didCaptureAutomatically,
      ),
    );
  }

  void _resetSteps() async {
    for (var p0 in _steps) {
      final int index = _steps.indexWhere(
        (p1) => p1.step == p0.step,
      );
      _steps[index] = _steps[index].copyWith(
        isCompleted: false,
      );
    }
    _didCloseEyes = false;
    if (_stepsKey.currentState?.currentIndex != 0) {
      _stepsKey.currentState?.reset();
    }
    if (mounted) {
      setState(() {});
    }
  }

  //* MARK: - Private Methods for UI Components
  //? =========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            //   fit: StackFit.expand,
            alignment: Alignment.center,
            children: [ CameraAwesomeBuilder.custom(
                      flashMode: FlashMode.auto,
                      previewFit: CameraPreviewFit.cover,
                      aspectRatio: CameraAspectRatios.ratio_16_9,
                      sensor: Sensors.front,
                      onImageForAnalysis: (img) => _processCameraImage(img),
                      imageAnalysisConfig: AnalysisConfig(
                        autoStart: true,
                        androidOptions: const AndroidAnalysisOptions.nv21(
                          width: 250,
                        ),
                        maxFramesPerSecond: 30,
                      ),
                      builder: (state, previewSize, previewRect) {
                        _cameraState = state;
                        return FDEazrDecoratorWidget(
                          cameraState: state,
                          faceDetectionStream: _faceDetectionController,
                          previewSize: previewSize,
                          previewRect: previewRect,
                         
                        );
                      },
                      saveConfig: SaveConfig.photo(
                        pathBuilder: () async {
                          final String fileName = "${FDEazrUtils.generate()}.jpg";
                          final String path = await getTemporaryDirectory().then(
                            (value) => value.path,
                          );
                          return "$path/$fileName";
                        },
                      ),
                    ),
                
                
                FDEazrStepOverlay(
                  key: _stepsKey,
                  steps: _steps,
                  onCompleted: () => _takePicture(
                    didCaptureAutomatically: true,
                  ),
                ),
           
            ],
          ),
        ),
      ),
    );
  }
}
