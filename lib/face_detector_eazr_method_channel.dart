import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'face_detector_eazr_platform_interface.dart';

/// An implementation of [FaceDetectorEazrPlatform] that uses method channels.
class MethodChannelFaceDetectorEazr extends FaceDetectorEazrPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('face_detector_eazr');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
