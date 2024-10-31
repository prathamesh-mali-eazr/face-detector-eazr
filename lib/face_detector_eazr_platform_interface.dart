import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'face_detector_eazr_method_channel.dart';

abstract class FaceDetectorEazrPlatform extends PlatformInterface {
  /// Constructs a FaceDetectorEazrPlatform.
  FaceDetectorEazrPlatform() : super(token: _token);

  static final Object _token = Object();

  static FaceDetectorEazrPlatform _instance = MethodChannelFaceDetectorEazr();

  /// The default instance of [FaceDetectorEazrPlatform] to use.
  ///
  /// Defaults to [MethodChannelFaceDetectorEazr].
  static FaceDetectorEazrPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FaceDetectorEazrPlatform] when
  /// they register themselves.
  static set instance(FaceDetectorEazrPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
