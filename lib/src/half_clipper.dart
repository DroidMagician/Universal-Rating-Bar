import 'package:flutter/material.dart';

/// Clips the left half of a widget for half-star rendering.
class HalfClipper extends CustomClipper<Rect> {
  /// Creates a clipper that keeps the left [fraction] of the widget.
  const HalfClipper({this.fraction = 0.5});

  /// Portion of the widget width to keep, from the left edge.
  final double fraction;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * fraction, size.height);
  }

  @override
  bool shouldReclip(HalfClipper oldClipper) =>
      oldClipper.fraction != fraction;
}
