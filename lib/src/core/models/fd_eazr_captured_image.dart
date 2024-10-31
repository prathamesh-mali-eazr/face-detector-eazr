import 'dart:convert';

class FDEazrCapturedImage {
  final String imgPath;
  final bool didCaptureAutomatically;
  FDEazrCapturedImage({
    required this.imgPath,
    required this.didCaptureAutomatically,
  });

  FDEazrCapturedImage copyWith({
    String? imgPath,
    bool? didCaptureAutomatically,
  }) {
    return FDEazrCapturedImage(
      imgPath: imgPath ?? this.imgPath,
      didCaptureAutomatically:
          didCaptureAutomatically ?? this.didCaptureAutomatically,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'imgPath': imgPath});
    result.addAll({'didCaptureAutomatically': didCaptureAutomatically});

    return result;
  }

  factory FDEazrCapturedImage.fromMap(Map<String, dynamic> map) {
    return FDEazrCapturedImage(
      imgPath: map['imgPath'] ?? '',
      didCaptureAutomatically: map['didCaptureAutomatically'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory FDEazrCapturedImage.fromJson(String source) =>
      FDEazrCapturedImage.fromMap(json.decode(source));

  @override
  String toString() =>
      'FDEazrCaptureImage(imgPath: $imgPath, didCaptureAutomatically: $didCaptureAutomatically)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FDEazrCapturedImage &&
        other.imgPath == imgPath &&
        other.didCaptureAutomatically == didCaptureAutomatically;
  }

  @override
  int get hashCode => imgPath.hashCode ^ didCaptureAutomatically.hashCode;
}
