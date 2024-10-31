import 'package:flutter/material.dart';

/// Radial gauge scope class.
class RadialGaugeScope extends InheritedWidget {
  /// Creates a object for Linear gauge scope.
  const RadialGaugeScope({
    super.key,
    this.enableLoadingAnimation = false,
    this.animationDuration = 2000,
    required super.child,
  });

  /// Specifies the load time animation for axis elements, range and
  /// pointers with [animationDuration].
  final bool enableLoadingAnimation;

  /// Specifies the load time animation duration.
  final int animationDuration;

  /// RadialGaugeScope method.
  static RadialGaugeScope of(BuildContext context) {
    late RadialGaugeScope scope;

    final Widget widget = context
        .getElementForInheritedWidgetOfExactType<RadialGaugeScope>()!
        .widget;

    if (widget is RadialGaugeScope) {
      scope = widget;
    }

    return scope;
  }

  @override
  bool updateShouldNotify(RadialGaugeScope oldWidget) {
    return enableLoadingAnimation != oldWidget.enableLoadingAnimation ||
        animationDuration != oldWidget.animationDuration;
  }
}
