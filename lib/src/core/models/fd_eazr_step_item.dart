
import 'dart:convert';

import 'package:face_detector_eazr/src/core/enums/fd_eazr_steps.dart';
import 'package:flutter/material.dart';

class FDEazrStepItem {
  //enum
  final FDEazrSteps step;
  final String title;
  final double? thresholdToCheck;
  final bool isCompleted;
  final Color? detectionColor;

  FDEazrStepItem({
    required this.step,
    required this.title,
    this.thresholdToCheck,
    required this.isCompleted,
    this.detectionColor,
  });

  FDEazrStepItem copyWith({
    FDEazrSteps? step,
    String? title,
    double? thresholdToCheck,
    bool? isCompleted,
    Color? detectionColor,
  }) {
    return FDEazrStepItem(
      step: step ?? this.step,
      title: title ?? this.title,
      thresholdToCheck: thresholdToCheck ?? this.thresholdToCheck,
      isCompleted: isCompleted ?? this.isCompleted,
      detectionColor: detectionColor ?? this.detectionColor,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'step': step.index});
    result.addAll({'title': title});
    if (thresholdToCheck != null) {
      result.addAll({'thresholdToCheck': thresholdToCheck});
    }
    result.addAll({'isCompleted': isCompleted});
    if (detectionColor != null) {
      result.addAll({'detectionColor': detectionColor!.value});
    }

    return result;
  }

  factory FDEazrStepItem.fromMap(Map<String, dynamic> map) {
    return FDEazrStepItem(
      step: FDEazrSteps.values[map['step'] ?? 0],
      title: map['title'] ?? '',
      thresholdToCheck: map['thresholdToCheck']?.toDouble(),
      isCompleted: map['isCompleted'] ?? false,
      detectionColor:
          map['detectionColor'] != null ? Color(map['detectionColor']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FDEazrStepItem.fromJson(String source) =>
      FDEazrStepItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FDEazrStepItem(step: $step, title: $title, thresholdToCheck: $thresholdToCheck, isCompleted: $isCompleted, detectionColor: $detectionColor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FDEazrStepItem &&
        other.step == step &&
        other.title == title &&
        other.thresholdToCheck == thresholdToCheck &&
        other.isCompleted == isCompleted &&
        other.detectionColor == detectionColor;
  }

  @override
  int get hashCode {
    return step.hashCode ^
        title.hashCode ^
        thresholdToCheck.hashCode ^
        isCompleted.hashCode ^
        detectionColor.hashCode;
  }
}
