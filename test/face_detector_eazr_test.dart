import 'package:flutter_test/flutter_test.dart';
import 'package:face_detector_eazr/face_detector_eazr_platform_interface.dart';
import 'package:face_detector_eazr/face_detector_eazr_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFaceDetectorEazrPlatform
    with MockPlatformInterfaceMixin
    implements FaceDetectorEazrPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FaceDetectorEazrPlatform initialPlatform = FaceDetectorEazrPlatform.instance;

  test('$MethodChannelFaceDetectorEazr is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFaceDetectorEazr>());
  });

  test('getPlatformVersion', () async {
    MockFaceDetectorEazrPlatform fakePlatform = MockFaceDetectorEazrPlatform();
    FaceDetectorEazrPlatform.instance = fakePlatform;
  });
}
