import 'dart:io';

// import 'package:collection/collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:face_detector_eazr/index.dart';

class FDEazrExpampleScreen extends StatefulWidget {
  const FDEazrExpampleScreen({super.key});

  @override
  State<FDEazrExpampleScreen> createState() => _FDEazrExpampleScreenState();
}

class _FDEazrExpampleScreenState extends State<FDEazrExpampleScreen> {
  //* MARK: - Private Variables
  //? =========================================================
  String? _capturedImagePath;
  final bool _isLoading = false;
  bool _startWithInfo = false;
  bool _allowAfterTimeOut = false;
  final List<FDEazrStepItem> _veificationSteps = [];
  int _timeOutDuration = 100;

  //* MARK: - Life Cycle Methods
  //? =========================================================
  @override
  void initState() {
    _initValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  //* MARK: - Private Methods for Business Logic
  //? =========================================================
  void _initValues() {
    _veificationSteps.addAll(
      [
        FDEazrStepItem(
          step: FDEazrSteps.blink,
          title: "Blink",
          isCompleted: false,
          detectionColor: Colors.transparent,
        ),
        // FDEazrStepItem(
        //   step: FDEazrSteps.smile,
        //   title: "Smile",
        //   isCompleted: false,
        //   detectionColor: Colors.green.shade800,
        // ),
      ],
    );
    FaceDetectorEazr.instance.configure(
      lineColor: Colors.white,
      dotColor: Colors.purple.shade800,
      dotSize: 2.0,
      lineWidth: 2,
      dashValues: [2.0, 5.0],
      displayDots: false,
      displayLines: true,
      thresholds: [
        FDEazrSmileDetectionThreshold(
          probability: 0.8,
        ),
        FDEazrBlinkDetectionThreshold(
          leftEyeProbability: 0.25,
          rightEyeProbability: 0.25,
        ),
      ],
    );
  }

  void _onStartLivelyness() async {
    setState(() => _capturedImagePath = null);
    final FDEazrCapturedImage? response =
        await FaceDetectorEazr.instance.detectLivelyness(
      context,
      config: FDEazrConfig(
        steps: _veificationSteps,
        startWithInfoScreen: _startWithInfo,
        maxSecToDetect: _timeOutDuration == 100 ? 2500 : _timeOutDuration,
        allowAfterMaxSec: _allowAfterTimeOut,
        captureButtonColor: Colors.red,
      ),
    );
    if (response == null) {
      return;
    }
    setState(
      () => _capturedImagePath = response.imgPath,
    );
  }

  String _getTitle(FDEazrSteps step) {
    switch (step) {
      case FDEazrSteps.blink:
        return "Blink";
      case FDEazrSteps.turnLeft:
        return "Turn Your Head Left";
      case FDEazrSteps.turnRight:
        return "Turn Your Head Right";
      case FDEazrSteps.smile:
        return "Smile";
    }
  }

  String _getSubTitle(FDEazrSteps step) {
    switch (step) {
      case FDEazrSteps.blink:
        return "Detects Blink on the face visible in camera";
      case FDEazrSteps.turnLeft:
        return "Detects Left Turn of the on the face visible in camera";
      case FDEazrSteps.turnRight:
        return "Detects Right Turn of the on the face visible in camera";
      case FDEazrSteps.smile:
        return "Detects Smile on the face visible in camera";
    }
  }

  bool _isSelected(FDEazrSteps step) {
    final FDEazrStepItem? doesExist = _veificationSteps.firstWhereOrNull(
      (p0) => p0.step == step,
    );
    return doesExist != null;
  }

  void _onStepValChanged(FDEazrSteps step, bool value) {
    if (!value && _veificationSteps.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Need to have atleast 1 step of verification",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.red.shade900,
        ),
      );
      return;
    }
    final FDEazrStepItem? doesExist = _veificationSteps.firstWhereOrNull(
      (p0) => p0.step == step,
    );

    if (doesExist == null && value) {
      _veificationSteps.add(
        FDEazrStepItem(
          step: step,
          title: _getTitle(step),
          isCompleted: false,
        ),
      );
    } else {
      if (!value) {
        _veificationSteps.removeWhere(
          (p0) => p0.step == step,
        );
      }
    }
    setState(() {});
  }

  //* MARK: - Private Methods for UI Components
  //? =========================================================
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "FDEazr Livelyness Detection",
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildContent(),
        Visibility(
          visible: _isLoading,
          child: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Spacer(
          flex: 4,
        ),
        Visibility(
          visible: _capturedImagePath != null,
          child: Expanded(
            flex: 7,
            child: Image.file(
              File(_capturedImagePath ?? ""),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Visibility(
          visible: _capturedImagePath != null,
          child: const Spacer(),
        ),
        Center(
          child: ElevatedButton(
            onPressed: _onStartLivelyness,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
            ),
            child: const Text(
              "Detect Livelyness",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(
              flex: 3,
            ),
            const Text(
              "Start with info screen:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            CupertinoSwitch(
              value: _startWithInfo,
              onChanged: (value) => setState(
                () => _startWithInfo = value,
              ),
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(
              flex: 3,
            ),
            const Text(
              "Allow after timer is completed:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            CupertinoSwitch(
              value: _allowAfterTimeOut,
              onChanged: (value) => setState(
                () => _allowAfterTimeOut = value,
              ),
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
        const Spacer(),
        Text(
          "Detection Time-out Duration(In Seconds): ${_timeOutDuration == 100 ? "No Limit" : _timeOutDuration}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Slider(
          min: 0,
          max: 100,
          value: _timeOutDuration.toDouble(),
          onChanged: (value) => setState(
            () => _timeOutDuration = value.toInt(),
          ),
        ),
        Expanded(
          flex: 14,
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: FDEazrSteps.values.length,
            itemBuilder: (context, index) => ExpansionTile(
              title: Text(
                _getTitle(
                  FDEazrSteps.values[index],
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    _getSubTitle(
                      FDEazrSteps.values[index],
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  trailing: CupertinoSwitch(
                    value: _isSelected(
                      FDEazrSteps.values[index],
                    ),
                    onChanged: (value) => _onStepValChanged(
                      FDEazrSteps.values[index],
                      value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
