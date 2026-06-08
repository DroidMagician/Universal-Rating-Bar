import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'half_clipper.dart';
import 'rating_state.dart';

/// Builds a single rating item for any supported render mode.
class RatingItemRenderer {
  const RatingItemRenderer({
    required this.renderMode,
    required this.size,
    this.filledIcon = Icons.star,
    this.emptyIcon = Icons.star_border,
    this.halfIcon,
    this.filledColor = Colors.amber,
    this.emptyColor = Colors.grey,
    this.halfColor,
    this.filledAsset,
    this.emptyAsset,
    this.halfAsset,
    this.filledWidget,
    this.emptyWidget,
    this.halfWidget,
    this.itemBuilder,
    this.halfClipFraction = 0.5,
    this.package,
    this.semanticLabel,
  });

  final RatingRenderMode renderMode;
  final double size;
  final IconData filledIcon;
  final IconData emptyIcon;
  final IconData? halfIcon;
  final Color filledColor;
  final Color emptyColor;
  final Color? halfColor;
  final String? filledAsset;
  final String? emptyAsset;
  final String? halfAsset;
  final Widget? filledWidget;
  final Widget? emptyWidget;
  final Widget? halfWidget;
  final RatingItemBuilder? itemBuilder;
  final double halfClipFraction;
  final String? package;
  final String? semanticLabel;

  Widget build(
    BuildContext context,
    int index,
    RatingState state, {
    double fillFraction = 0.5,
  }) {
    if (itemBuilder != null) {
      return SizedBox(
        width: size,
        height: size,
        child: itemBuilder!(context, index, state),
      );
    }

    return switch (renderMode) {
      RatingRenderMode.icon => _buildIcon(state, fillFraction),
      RatingRenderMode.asset => _buildAsset(state, fillFraction),
      RatingRenderMode.widget => _buildWidget(state, fillFraction),
    };
  }

  Widget _buildIcon(RatingState state, double fillFraction) {
    return switch (state) {
      RatingState.full => Icon(
          filledIcon,
          size: size,
          color: filledColor,
          semanticLabel: semanticLabel,
        ),
      RatingState.half => _buildHalfIcon(fillFraction),
      RatingState.empty => Icon(
          emptyIcon,
          size: size,
          color: emptyColor,
          semanticLabel: semanticLabel,
        ),
    };
  }

  Widget _buildHalfIcon(double fillFraction) {
    final resolvedHalfIcon = _resolveHalfIcon();
    final isExactHalf = (fillFraction - halfClipFraction).abs() < 0.001;

    if (resolvedHalfIcon != null && isExactHalf) {
      return Icon(
        resolvedHalfIcon,
        size: size,
        color: halfColor ?? filledColor,
        semanticLabel: semanticLabel,
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            emptyIcon,
            size: size,
            color: emptyColor,
            semanticLabel: semanticLabel,
          ),
          ClipRect(
            clipper: HalfClipper(fraction: fillFraction),
            child: Icon(
              filledIcon,
              size: size,
              color: halfColor ?? filledColor,
              semanticLabel: semanticLabel,
            ),
          ),
        ],
      ),
    );
  }

  IconData? _resolveHalfIcon() {
    if (halfIcon != null) {
      return halfIcon;
    }
    if (filledIcon == Icons.star) {
      return Icons.star_half;
    }
    if (filledIcon == Icons.star_border) {
      return Icons.star_half;
    }
    if (filledIcon == Icons.star_outline) {
      return Icons.star_half;
    }
    return null;
  }

  Widget _buildAsset(RatingState state, double fillFraction) {
    final empty = _assetImage(emptyAsset!);
    final filled = _assetImage(filledAsset!);

    return switch (state) {
      RatingState.full => filled,
      RatingState.half when halfAsset != null && fillFraction == halfClipFraction =>
        _assetImage(halfAsset!),
      RatingState.half => _stackHalfAsset(
          empty: empty,
          filled: filled,
          fraction: fillFraction,
        ),
      RatingState.empty => empty,
    };
  }

  Widget _buildWidget(RatingState state, double fillFraction) {
    return switch (state) {
      RatingState.full => _sized(filledWidget!),
      RatingState.half when halfWidget != null && fillFraction == halfClipFraction =>
        _sized(halfWidget!),
      RatingState.half => _stackHalfWidget(
          empty: _sized(emptyWidget!),
          filled: _sized(filledWidget!),
          fraction: fillFraction,
        ),
      RatingState.empty => _sized(emptyWidget!),
    };
  }

  Widget _sized(Widget child) {
    return SizedBox(width: size, height: size, child: child);
  }

  Widget _stackHalfAsset({
    required Widget empty,
    required Widget filled,
    required double fraction,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          empty,
          ClipRect(
            clipper: HalfClipper(fraction: fraction),
            child: filled,
          ),
        ],
      ),
    );
  }

  Widget _stackHalfWidget({
    required Widget empty,
    required Widget filled,
    required double fraction,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          empty,
          ClipRect(
            clipper: HalfClipper(fraction: fraction),
            child: filled,
          ),
        ],
      ),
    );
  }

  Widget _assetImage(String path) {
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');
    final isSvg = path.toLowerCase().endsWith('.svg');

    if (isSvg) {
      if (isNetwork) {
        return SvgPicture.network(
          path,
          width: size,
          height: size,
          semanticsLabel: semanticLabel,
        );
      }
      return SvgPicture.asset(
        path,
        width: size,
        height: size,
        package: package,
        semanticsLabel: semanticLabel,
      );
    }

    if (isNetwork) {
      return Image.network(
        path,
        width: size,
        height: size,
        semanticLabel: semanticLabel,
      );
    }

    return Image.asset(
      path,
      width: size,
      height: size,
      package: package,
      semanticLabel: semanticLabel,
    );
  }
}

/// Signature for fully custom per-item rendering.
typedef RatingItemBuilder = Widget Function(
  BuildContext context,
  int index,
  RatingState state,
);
