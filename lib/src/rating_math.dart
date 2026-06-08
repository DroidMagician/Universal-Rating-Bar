import 'rating_state.dart';

/// Utility functions for rating calculations.
class RatingMath {
  const RatingMath._();

  /// Returns the visual [RatingState] for [index] given the overall [rating].
  static RatingState stateForIndex({
    required int index,
    required double rating,
    required bool allowHalfRating,
    required double precision,
  }) {
    final itemValue = index + 1.0;

    if (rating >= itemValue) {
      return RatingState.full;
    }
    if (allowHalfRating && rating > index) {
      return RatingState.half;
    }
    return RatingState.empty;
  }

  /// Returns the filled fraction for [index] when [rating] is between two items.
  ///
  /// For example, a [rating] of `3.7` at [index] `3` returns `0.7`.
  static double fillFractionForIndex({
    required int index,
    required double rating,
    required bool allowHalfRating,
    required double precision,
  }) {
    if (!allowHalfRating) {
      return 0;
    }

    final itemValue = index + 1.0;
    if (rating >= itemValue) {
      return 1;
    }
    if (rating <= index) {
      return 0;
    }

    final fraction = rating - index;
    if (precision >= 1) {
      return fraction;
    }

    final snappedSteps = (fraction / precision).round() * precision;
    return snappedSteps.clamp(0, 1);
  }

  /// Snaps [rawRating] to the nearest step defined by [precision].
  static double snap(double rawRating, double precision) {
    if (precision <= 0) {
      return rawRating;
    }
    return (rawRating / precision).round() * precision;
  }

  /// Clamps and snaps a rating within `[minRating, itemCount]`.
  static double normalize({
    required double rawRating,
    required int itemCount,
    required double precision,
    required double minRating,
    required bool allowHalfRating,
  }) {
    final minAllowed = allowHalfRating ? minRating : minRating.ceilToDouble();
    final snapped = snap(rawRating, precision);
    return snapped.clamp(minAllowed, itemCount.toDouble());
  }

  /// Converts a horizontal/vertical local position to a rating value.
  static double ratingFromPosition({
    required double position,
    required double itemExtent,
    required int itemCount,
    required double spacing,
    required double precision,
    required double minRating,
    required bool allowHalfRating,
    required bool isVertical,
  }) {
    final totalSpacing = spacing * (itemCount - 1);
    final totalExtent = (itemExtent * itemCount) + totalSpacing;

    final clampedPosition = position.clamp(0.0, totalExtent);
    final stride = itemExtent + spacing;
    final rawIndex = clampedPosition / stride;
    final rawRating = rawIndex + minRating;

    return normalize(
      rawRating: rawRating,
      itemCount: itemCount,
      precision: precision,
      minRating: minRating,
      allowHalfRating: allowHalfRating,
    );
  }

  /// Converts a tap within a single item to a rating value.
  static double ratingFromItemTap({
    required int index,
    required double localPosition,
    required double itemExtent,
    required bool allowHalfRating,
    required double precision,
    required double minRating,
  }) {
    final base = index + 1 + minRating;
    if (!allowHalfRating) {
      return base;
    }

    final isLeftHalf = localPosition < itemExtent / 2;
    final raw = isLeftHalf ? base - precision : base;
    return normalize(
      rawRating: raw,
      itemCount: index + 1,
      precision: precision,
      minRating: minRating,
      allowHalfRating: allowHalfRating,
    );
  }
}
