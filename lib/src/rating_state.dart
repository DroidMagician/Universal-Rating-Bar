/// Visual state of a single rating item.
enum RatingState {
  /// Fully selected item.
  full,

  /// Partially selected item (half or fractional clip).
  half,

  /// Unselected item.
  empty,
}

/// How each rating item is rendered.
enum RatingRenderMode {
  /// Material [IconData] with optional colors.
  icon,

  /// Local or network image assets (SVG / PNG / JPG).
  asset,

  /// Custom widgets or [itemBuilder].
  widget,
}
