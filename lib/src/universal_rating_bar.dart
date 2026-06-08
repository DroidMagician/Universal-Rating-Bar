import 'package:flutter/material.dart';

import 'rating_item_renderer.dart';
import 'rating_math.dart';
import 'rating_state.dart';

/// A fully customizable rating bar supporting icons, assets, and custom widgets.
///
/// Use the default constructor for Material star icons, [UniversalRatingBar.icon]
/// for custom icons, [UniversalRatingBar.asset] for SVG/PNG assets, and
/// [UniversalRatingBar.custom] for widget-based or [itemBuilder] rendering.
///
/// Also exported as [FlexRatingBar].
class UniversalRatingBar extends StatefulWidget {
  /// Creates a rating bar with default star icons.
  const UniversalRatingBar({
    super.key,
    required this.rating,
    this.itemCount = 5,
    this.size = 32,
    this.spacing = 2,
    this.onRatingChanged,
    this.allowHalfRating = true,
    this.isInteractive = true,
    this.ignoreGestures = false,
    this.updateOnDrag = true,
    this.direction = Axis.horizontal,
    this.precision = 0.5,
    this.minRating = 0,
    this.animateRatingChange = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.enableScaleEffect = false,
    this.scaleFactor = 1.15,
    this.filledIcon = Icons.star,
    this.emptyIcon = Icons.star_border,
    this.halfIcon,
    this.filledColor = Colors.amber,
    this.emptyColor = Colors.grey,
    this.halfColor,
    this.semanticLabel,
    this.itemBuilder,
    this.halfClipFraction = 0.5,
  })  : renderMode = RatingRenderMode.icon,
        filledAsset = null,
        emptyAsset = null,
        halfAsset = null,
        filledWidget = null,
        emptyWidget = null,
        halfWidget = null,
        assetPackage = null;

  /// Creates a rating bar using [IconData] with optional colors.
  const UniversalRatingBar.icon({
    super.key,
    required this.rating,
    this.itemCount = 5,
    this.size = 32,
    this.spacing = 2,
    this.onRatingChanged,
    this.allowHalfRating = true,
    this.isInteractive = true,
    this.ignoreGestures = false,
    this.updateOnDrag = true,
    this.direction = Axis.horizontal,
    this.precision = 0.5,
    this.minRating = 0,
    this.animateRatingChange = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.enableScaleEffect = false,
    this.scaleFactor = 1.15,
    required this.filledIcon,
    required this.emptyIcon,
    this.halfIcon,
    this.filledColor = Colors.amber,
    this.emptyColor = Colors.grey,
    this.halfColor,
    this.semanticLabel,
    this.itemBuilder,
    this.halfClipFraction = 0.5,
  })  : renderMode = RatingRenderMode.icon,
        filledAsset = null,
        emptyAsset = null,
        halfAsset = null,
        filledWidget = null,
        emptyWidget = null,
        halfWidget = null,
        assetPackage = null;

  /// Creates a rating bar using image assets (SVG, PNG, JPG, or network URLs).
  const UniversalRatingBar.asset({
    super.key,
    required this.rating,
    required this.filledAsset,
    required this.emptyAsset,
    this.halfAsset,
    this.itemCount = 5,
    this.size = 32,
    this.spacing = 2,
    this.onRatingChanged,
    this.allowHalfRating = true,
    this.isInteractive = true,
    this.ignoreGestures = false,
    this.updateOnDrag = true,
    this.direction = Axis.horizontal,
    this.precision = 0.5,
    this.minRating = 0,
    this.animateRatingChange = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.enableScaleEffect = false,
    this.scaleFactor = 1.15,
    this.semanticLabel,
    this.itemBuilder,
    this.halfClipFraction = 0.5,
    this.assetPackage,
  })  : renderMode = RatingRenderMode.asset,
        filledIcon = Icons.star,
        emptyIcon = Icons.star_border,
        halfIcon = null,
        filledColor = Colors.amber,
        emptyColor = Colors.grey,
        halfColor = null,
        filledWidget = null,
        emptyWidget = null,
        halfWidget = null;

  /// Creates a rating bar using custom widgets or [itemBuilder].
  const UniversalRatingBar.custom({
    super.key,
    required this.rating,
    this.filledWidget,
    this.emptyWidget,
    this.halfWidget,
    this.itemBuilder,
    this.itemCount = 5,
    this.size = 32,
    this.spacing = 2,
    this.onRatingChanged,
    this.allowHalfRating = true,
    this.isInteractive = true,
    this.ignoreGestures = false,
    this.updateOnDrag = true,
    this.direction = Axis.horizontal,
    this.precision = 0.5,
    this.minRating = 0,
    this.animateRatingChange = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.enableScaleEffect = false,
    this.scaleFactor = 1.15,
    this.semanticLabel,
    this.halfClipFraction = 0.5,
  })  : renderMode = RatingRenderMode.widget,
        filledIcon = Icons.star,
        emptyIcon = Icons.star_border,
        halfIcon = null,
        filledColor = Colors.amber,
        emptyColor = Colors.grey,
        halfColor = null,
        filledAsset = null,
        emptyAsset = null,
        halfAsset = null,
        assetPackage = null,
        assert(
          itemBuilder != null ||
              (filledWidget != null && emptyWidget != null),
          'Provide itemBuilder or both filledWidget and emptyWidget.',
        );

  /// Current rating value.
  final double rating;

  /// Number of rating items.
  final int itemCount;

  /// Width and height of each item.
  final double size;

  /// Space between items along the main axis.
  final double spacing;

  /// Called when the user changes the rating.
  final ValueChanged<double>? onRatingChanged;

  /// Whether half (or fractional) ratings are allowed.
  final bool allowHalfRating;

  /// When `false`, the bar is display-only.
  final bool isInteractive;

  /// When `true`, all gestures are ignored regardless of [isInteractive].
  final bool ignoreGestures;

  /// When `true`, horizontal/vertical drag updates the rating.
  final bool updateOnDrag;

  /// Layout direction of the rating bar.
  final Axis direction;

  /// Step size for rating values (e.g. `0.5`, `0.25`, `0.1`).
  final double precision;

  /// Minimum rating value.
  final double minRating;

  /// Animates rating changes when `true`.
  final bool animateRatingChange;

  /// Duration used when [animateRatingChange] is enabled.
  final Duration animationDuration;

  /// Scales items briefly when the rating changes.
  final bool enableScaleEffect;

  /// Scale multiplier used with [enableScaleEffect].
  final double scaleFactor;

  /// How each item is rendered.
  final RatingRenderMode renderMode;

  final IconData filledIcon;
  final IconData emptyIcon;
  final IconData? halfIcon;
  final Color filledColor;
  final Color emptyColor;
  final Color? halfColor;

  final String? filledAsset;
  final String? emptyAsset;
  final String? halfAsset;
  final String? assetPackage;

  final Widget? filledWidget;
  final Widget? emptyWidget;
  final Widget? halfWidget;
  final RatingItemBuilder? itemBuilder;

  /// Fraction of the filled layer shown for half items when no half asset/widget
  /// is provided.
  final double halfClipFraction;

  /// Accessibility label for asset images.
  final String? semanticLabel;

  @override
  State<UniversalRatingBar> createState() => _UniversalRatingBarState();
}

class _UniversalRatingBarState extends State<UniversalRatingBar>
    with SingleTickerProviderStateMixin {
  late double _displayRating;
  int? _activeIndex;
  late AnimationController _animationController;
  late Animation<double> _ratingAnimation;

  bool get _canInteract =>
      widget.isInteractive &&
      !widget.ignoreGestures &&
      widget.onRatingChanged != null;

  @override
  void initState() {
    super.initState();
    _displayRating = widget.rating;
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _ratingAnimation = AlwaysStoppedAnimation(_displayRating);
  }

  @override
  void didUpdateWidget(UniversalRatingBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }

    if (oldWidget.rating != widget.rating) {
      _animateTo(widget.rating);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    if (!widget.animateRatingChange) {
      setState(() => _displayRating = target);
      return;
    }

    _ratingAnimation = Tween<double>(
      begin: _displayRating,
      end: target,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() => _displayRating = _ratingAnimation.value);
      });

    _animationController
      ..reset()
      ..forward();
  }

  void _updateRating(double value) {
    final normalized = RatingMath.normalize(
      rawRating: value,
      itemCount: widget.itemCount,
      precision: widget.precision,
      minRating: widget.minRating,
      allowHalfRating: widget.allowHalfRating,
    );

    if (normalized == widget.rating) {
      return;
    }
    widget.onRatingChanged?.call(normalized);
  }

  void _handleBarPosition(Offset localPosition) {
    if (!_canInteract) {
      return;
    }

    final position = widget.direction == Axis.horizontal
        ? localPosition.dx
        : localPosition.dy;

    final rating = RatingMath.ratingFromPosition(
      position: position,
      itemExtent: widget.size,
      itemCount: widget.itemCount,
      spacing: widget.spacing,
      precision: widget.precision,
      minRating: widget.minRating,
      allowHalfRating: widget.allowHalfRating,
      isVertical: widget.direction == Axis.vertical,
    );

    _updateRating(rating);
  }

  void _handleItemTap(int index, Offset localPosition) {
    if (!_canInteract) {
      return;
    }

    final axisOffset = widget.direction == Axis.horizontal
        ? localPosition.dx
        : localPosition.dy;

    final rating = RatingMath.ratingFromItemTap(
      index: index,
      localPosition: axisOffset,
      itemExtent: widget.size,
      allowHalfRating: widget.allowHalfRating,
      precision: widget.precision,
      minRating: widget.minRating,
    );

    _updateRating(rating);
  }

  RatingItemRenderer get _renderer => RatingItemRenderer(
        renderMode: widget.itemBuilder != null
            ? RatingRenderMode.widget
            : widget.renderMode,
        size: widget.size,
        filledIcon: widget.filledIcon,
        emptyIcon: widget.emptyIcon,
        halfIcon: widget.halfIcon,
        filledColor: widget.filledColor,
        emptyColor: widget.emptyColor,
        halfColor: widget.halfColor,
        filledAsset: widget.filledAsset,
        emptyAsset: widget.emptyAsset,
        halfAsset: widget.halfAsset,
        filledWidget: widget.filledWidget,
        emptyWidget: widget.emptyWidget,
        halfWidget: widget.halfWidget,
        itemBuilder: widget.itemBuilder,
        halfClipFraction: widget.halfClipFraction,
        package: widget.assetPackage,
        semanticLabel: widget.semanticLabel,
      );

  Widget _buildItem(int index) {
    final state = RatingMath.stateForIndex(
      index: index,
      rating: _displayRating,
      allowHalfRating: widget.allowHalfRating,
      precision: widget.precision,
    );
    final fillFraction = RatingMath.fillFractionForIndex(
      index: index,
      rating: _displayRating,
      allowHalfRating: widget.allowHalfRating,
      precision: widget.precision,
    );

    Widget child = _renderer.build(
      context,
      index,
      state,
      fillFraction: fillFraction,
    );

    if (widget.enableScaleEffect && _activeIndex == index) {
      child = TweenAnimationBuilder<double>(
        tween: Tween(begin: 1, end: widget.scaleFactor),
        duration: const Duration(milliseconds: 120),
        builder: (context, scale, item) {
          return Transform.scale(scale: scale, child: item);
        },
        child: child,
      );
    }

    if (!_canInteract) {
      return Padding(
        padding: _itemPadding,
        child: child,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) => setState(() => _activeIndex = index),
      onTapUp: (details) {
        _handleItemTap(index, details.localPosition);
        setState(() => _activeIndex = null);
      },
      onTapCancel: () => setState(() => _activeIndex = null),
      onTap: () => _handleItemTap(
        index,
        Offset(widget.size / 2, widget.size / 2),
      ),
      child: Padding(
        padding: _itemPadding,
        child: child,
      ),
    );
  }

  EdgeInsets get _itemPadding {
    final halfSpacing = widget.spacing / 2;
    return widget.direction == Axis.horizontal
        ? EdgeInsets.symmetric(horizontal: halfSpacing)
        : EdgeInsets.symmetric(vertical: halfSpacing);
  }

  @override
  Widget build(BuildContext context) {
    final children = List.generate(widget.itemCount, _buildItem);

    final row = widget.direction == Axis.horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: children)
        : Column(mainAxisSize: MainAxisSize.min, children: children);

    if (!_canInteract || !widget.updateOnDrag) {
      return row;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: widget.direction == Axis.horizontal
          ? (details) => _handleBarPosition(details.localPosition)
          : null,
      onVerticalDragUpdate: widget.direction == Axis.vertical
          ? (details) => _handleBarPosition(details.localPosition)
          : null,
      onTapDown: (details) => _handleBarPosition(details.localPosition),
      child: row,
    );
  }
}

/// Alias for [UniversalRatingBar] matching the original design name.
typedef FlexRatingBar = UniversalRatingBar;
