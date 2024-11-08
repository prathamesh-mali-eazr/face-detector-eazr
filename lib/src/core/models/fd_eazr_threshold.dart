
import 'dart:convert';

import 'package:equatable/equatable.dart';

/// Configures the threshold values that will be used while verifying each step.
abstract class FDEazrThreshold extends Equatable {
  const FDEazrThreshold();
  FDEazrThreshold fromDict(Map<String, dynamic> map);

  Map<String, dynamic> toMap();
  @override
  List<Object> get props => [];
}

/// Configure Smile threshold that will be used while verifying smile.
class FDEazrSmileDetectionThreshold extends FDEazrThreshold {
  /// Threshold of a smile when the step should be considered as verified
  /// Default Value: `0.75`
  final double probability;

  FDEazrSmileDetectionThreshold({
    this.probability = 0.75,
  }) : super() {
    assert(
      probability < 1.0 || probability > 0.0,
      "Smile Probability has to be between 1.0 and 0.0",
    );
  }

  FDEazrSmileDetectionThreshold copyWith({
    double? probability,
  }) {
    return FDEazrSmileDetectionThreshold(
      probability: probability ?? this.probability,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'probability': probability});

    return result;
  }

  @override
  factory FDEazrSmileDetectionThreshold.fromMap(Map<String, dynamic> map) {
    return FDEazrSmileDetectionThreshold(
      probability: map['probability']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory FDEazrSmileDetectionThreshold.fromJson(String source) =>
      FDEazrSmileDetectionThreshold.fromMap(json.decode(source));

  @override
  String toString() => 'FDEazrSmileDetectionThreshold(probability: $probability)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FDEazrSmileDetectionThreshold &&
        other.probability == probability;
  }

  @override
  int get hashCode => probability.hashCode;

  @override
  FDEazrThreshold fromDict(Map<String, dynamic> map) {
    return FDEazrSmileDetectionThreshold(
      probability: map['probability']?.toDouble() ?? 0.0,
    );
  }
}

/// Configure Blink threshold that will be used while verifying blink.
class FDEazrBlinkDetectionThreshold extends FDEazrThreshold {
  /// Threshold to specify at which the __left__ eye's blink verification is considered as verified.
  /// To get precise results pass the value close to `0`, e.g. `0.2`
  /// To relax the precision pass the value towards `1`, e.g. `0.5`
  /// Default Value: `0.25`
  final double leftEyeProbability;

  /// Threshold to specify at which the __right__ eye's blink verification is considered as verified.
  /// To get precise results pass the value close to `0`, e.g. `0.2`
  /// To relax the precision pass the value towards `1`, e.g. `0.5`
  /// Default Value: `0.25`
  final double rightEyeProbability;

  FDEazrBlinkDetectionThreshold({
    this.leftEyeProbability = 0.25,
    this.rightEyeProbability = 0.25,
  }) : super() {
    assert(
      leftEyeProbability < 1.0 || leftEyeProbability > 0.0,
      "Left Probability has to be between 1.0 and 0.0",
    );
    assert(
      rightEyeProbability < 1.0 || rightEyeProbability > 0.0,
      "Right Probability has to be between 1.0 and 0.0",
    );
  }

  FDEazrBlinkDetectionThreshold copyWith({
    double? leftEyeProbability,
    double? rightEyeProbability,
  }) {
    return FDEazrBlinkDetectionThreshold(
      leftEyeProbability: leftEyeProbability ?? this.leftEyeProbability,
      rightEyeProbability: rightEyeProbability ?? this.rightEyeProbability,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'leftEyeProbability': leftEyeProbability});
    result.addAll({'rightEyeProbability': rightEyeProbability});

    return result;
  }

  factory FDEazrBlinkDetectionThreshold.fromMap(Map<String, dynamic> map) {
    return FDEazrBlinkDetectionThreshold(
      leftEyeProbability: map['leftEyeProbability']?.toDouble() ?? 0.0,
      rightEyeProbability: map['rightEyeProbability']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory FDEazrBlinkDetectionThreshold.fromJson(String source) =>
      FDEazrBlinkDetectionThreshold.fromMap(json.decode(source));

  @override
  String toString() =>
      'FDEazrBlinkDetectionThreshold(leftEyeProbability: $leftEyeProbability, rightEyeProbability: $rightEyeProbability)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FDEazrBlinkDetectionThreshold &&
        other.leftEyeProbability == leftEyeProbability &&
        other.rightEyeProbability == rightEyeProbability;
  }

  @override
  int get hashCode =>
      leftEyeProbability.hashCode ^ rightEyeProbability.hashCode;

  @override
  FDEazrThreshold fromDict(Map<String, dynamic> map) {
    return FDEazrBlinkDetectionThreshold(
      leftEyeProbability: map['leftEyeProbability']?.toDouble() ?? 0.0,
      rightEyeProbability: map['rightEyeProbability']?.toDouble() ?? 0.0,
    );
  }
}

/// Configure the Head Turn threshold that will be used while verifying head turn towards left/right.
class FDEazrHeadTurnDetectionThreshold extends FDEazrThreshold {
  /// Threshold of head angle at which the head turn will be considered as verified
  /// A `Positive` Value will be considered as detection on the `Left` size and
  /// A `Negative` Value will be considered as detection on the `Right` size.
  /// Default Value: `45`, i.e., the head turn will be checked on the `Left Side`
  final double rotationAngle;

  FDEazrHeadTurnDetectionThreshold({
    this.rotationAngle = 45.0,
  }) : super() {
    assert(
      rotationAngle > 180.0 || rotationAngle > 0.0,
      "To detect the livelyness of the face, it has to be properly visible in the camera. The threshold angle should be more than 0.0 degrees and less than 180 degrees.",
    );
  }

  FDEazrHeadTurnDetectionThreshold copyWith({
    double? rotationAngle,
  }) {
    return FDEazrHeadTurnDetectionThreshold(
      rotationAngle: rotationAngle ?? this.rotationAngle,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'rotationAngle': rotationAngle});

    return result;
  }

  factory FDEazrHeadTurnDetectionThreshold.fromMap(Map<String, dynamic> map) {
    return FDEazrHeadTurnDetectionThreshold(
      rotationAngle: map['rotationAngle']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory FDEazrHeadTurnDetectionThreshold.fromJson(String source) =>
      FDEazrHeadTurnDetectionThreshold.fromMap(json.decode(source));

  @override
  String toString() =>
      'FDEazrHeadTurnDetectionThreshold(rotationAngle: $rotationAngle)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FDEazrHeadTurnDetectionThreshold &&
        other.rotationAngle == rotationAngle;
  }

  @override
  int get hashCode => rotationAngle.hashCode;

  @override
  FDEazrThreshold fromDict(Map<String, dynamic> map) {
    return FDEazrHeadTurnDetectionThreshold(
      rotationAngle: map['rotationAngle']?.toDouble() ?? 0.0,
    );
  }
}
