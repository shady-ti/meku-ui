import 'dart:math';
import 'dart:ui';

Color randomColor() {
  var generator = Random.secure();

  return Color.fromARGB(
    1,
    generator.nextInt(256),
    generator.nextInt(256),
    generator.nextInt(256),
  );
}

/// A few extension methods on [Color] to help with UI color palette generation
extension ColorPaletteHelpers on Color {
  /// Compute the [contrast ratio](https://www.w3.org/TR/WCAG20/#contrast-ratiodef)
  /// when placed with the given color
  double computeContrastRatioAgainst(Color other) {
    var contrast = (computeLuminance() + 0.05) / (other.computeLuminance() + 0.05);

    return contrast > 1 ? contrast : 1 / contrast;
  }
}
