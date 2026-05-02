import 'package:flutter/material.dart';

/// Renders a category icon from the [icon] field stored on a [Category].
///
/// The [icon] field is either:
/// - An emoji string (e.g. "🍔") — rendered as [Text]
/// - A legacy hex codepoint string for a Material icon (e.g. "e318") —
///   rendered as [Text] using the MaterialIcons font, which avoids the
///   non-constant [IconData] tree-shaking restriction in release builds.
Widget buildCategoryIcon(
  String icon, {
  required Color color,
  required double size,
}) {
  if (icon.isEmpty) {
    return Icon(Icons.category_outlined, color: color, size: size);
  }

  final codePoint = int.tryParse(icon, radix: 16);
  if (codePoint != null) {
    // Render the Material icon glyph as Text to avoid non-constant IconData.
    return Text(
      String.fromCharCode(codePoint),
      style: TextStyle(
        fontFamily: 'MaterialIcons',
        fontSize: size,
        color: color,
      ),
    );
  }

  // Emoji / text icon
  return Text(
    icon,
    style: TextStyle(fontSize: size * 0.9),
  );
}
