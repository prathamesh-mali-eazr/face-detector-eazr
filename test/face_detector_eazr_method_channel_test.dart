import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:face_detector_eazr/face_detector_eazr_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFaceDetectorEazr platform = MethodChannelFaceDetectorEazr();
  const MethodChannel channel = MethodChannel('face_detector_eazr');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
