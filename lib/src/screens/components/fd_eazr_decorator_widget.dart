
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:face_detector_eazr/src/core/custom_painters/android_face_detector_painter.dart';
import 'package:face_detector_eazr/src/core/models/face_detection_model.dart';
import 'package:flutter/material.dart';

class FDEazrDecoratorWidget extends StatelessWidget {
  final CameraState cameraState;
  final Stream<FaceDetectionModel> faceDetectionStream;
  final PreviewSize previewSize;
  final Rect previewRect;
  final Color? detectionColor;

  const FDEazrDecoratorWidget({
    super.key,
    required this.cameraState,
    required this.faceDetectionStream,
    required this.previewSize,
    required this.previewRect,
    this.detectionColor,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: StreamBuilder(
        stream: cameraState.sensorConfig$,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return StreamBuilder<FaceDetectionModel>(
              stream: faceDetectionStream,
              builder: (_, faceModelSnapshot) {
                if (!faceModelSnapshot.hasData) return const SizedBox();
                return CustomPaint(
                  painter: FDEazrAndroidFaceDetectorPainter(
                    model: faceModelSnapshot.requireData,
                    previewSize: previewSize,
                    previewRect: previewRect,
                    isBackCamera: snapshot.requireData.sensor == Sensors.back,
                    detectionColor: detectionColor,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
