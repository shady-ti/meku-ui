/// {@category BACKEND}
/// {@category UTILS}
///
/// [Mēku's take on Colors](../colors.md)

// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/widgets.dart';

/// A few extension methods on [Color] to help with UI color palette generation
extension HSLHelpers on HSLColor {
  static final _generator = Random.secure();

  /// generate a random color.
  static randomColor() {
    return HSLColor.fromAHSL(
      1,
      _generator.nextDouble() * 360,
      _generator.nextDouble(),
      _generator.nextDouble(),
    );
  }

  /// vary the saturation and lightness of the given color.
  HSLColor varyColor() {
    if (_generator.nextInt(1000) == 1) {
      return withHue((hue + (_generator.nextDouble() * 36)) % 360)
          .withLightness((lightness + (_generator.nextDouble() * 0.01)) % 1)
          .withSaturation((saturation + (_generator.nextDouble() * 0.01)) % 1);
    } else {
      return withLightness((lightness + (_generator.nextDouble() * 0.01)) % 1)
          .withSaturation((saturation + (_generator.nextDouble() * 0.01)) % 1);
    }
  }

  /// Compute the [relativeLuminance](https://en.wikipedia.org/wiki/Relative_luminance).
  /// Is very computationally expensive.
  double computeLuminance() {
    return toColor().computeLuminance();
  }

  /// Compute the [contrast ratio](https://www.w3.org/TR/WCAG20/#contrast-ratiodef)
  /// when placed with the given color. Is very computationally expensive.
  double computeContrastRatioAgainst(HSLColor other) {
    var contrast = (computeLuminance() + 0.05) / (other.computeLuminance() + 0.05);

    return contrast > 1 ? contrast : 1 / contrast;
  }
}

/// A Color Palette creator for Mēku
class ColorPalette {
  /// color for background depth—0
  late HSLColor body0;

  /// color for background depth—1 (above [body0])
  late HSLColor body1;

  /// color for background depth—2 (above [body1])
  late HSLColor body2;

  /// color for text, borders, UI activity state, & tints
  late HSLColor top;

  /// color to indicate positive updates
  late HSLColor accentGood;

  /// color to indicate negative updates
  late HSLColor accentBad;

  /// generate a dark themed color palette
  static Future<ColorPalette> generateDarkThemeFrom({
    required HSLColor bodyColor,
  }) async {
    var darkTheme = ColorPalette();

    await darkTheme.generateDarkBodyColors(bodyColor: bodyColor);

    await darkTheme.generateTopColor();

    await darkTheme.generateAccents();

    return darkTheme;
  }

  /// generate a dark themed color palette
  static Future<ColorPalette> generateLightThemeFrom({
    required HSLColor bodyColor,
  }) async {
    var lightTheme = ColorPalette();

    await lightTheme.generateLightBodyColors(bodyColor: bodyColor);

    await lightTheme.generateTopColor();

    await lightTheme.generateAccents();

    return lightTheme;
  }

  /// check if the generated color palette has sufficient contrast according to
  /// the established guidelines
  Future<bool> hasSufficientContrast() async {
    return body2.computeContrastRatioAgainst(top) > 7 &&
        body2.computeContrastRatioAgainst(accentGood) > 3 &&
        body2.computeContrastRatioAgainst(accentBad) > 3 &&
        accentGood.computeContrastRatioAgainst(top) > 3 &&
        accentBad.computeContrastRatioAgainst(top) > 3;
  }

  /// generate body colors ([body0], [body1], & [body2]) for a dark themed
  /// color palette
  Future<List<HSLColor>> generateDarkBodyColors({
    required HSLColor bodyColor,
    bool isDarkTheme = true,
  }) async {
    var baseColor = bodyColor.withLightness(0);
    body0 = baseColor;

    var topContrast = 1.0;

    for (double i = 0; i <= 1; i += 0.01) {
      if (baseColor.computeContrastRatioAgainst(body0.withLightness(i)) > topContrast) {
        topContrast = baseColor.computeContrastRatioAgainst(body0.withLightness(i));
        body0 = body0.withLightness(i);
      }

      if (topContrast > 1.1) {
        topContrast = 1;
        break;
      }
    }

    body1 = body0;

    for (double i = body0.lightness; i <= 1; i += 0.01) {
      if (body0.computeContrastRatioAgainst(body1.withLightness(i)) > topContrast) {
        topContrast = body0.computeContrastRatioAgainst(body1.withLightness(i));
        body1 = body1.withLightness(i);
      }

      if (topContrast > 1.1) {
        topContrast = 1;
        break;
      }
    }

    body2 = body1;

    for (double i = body1.lightness; i <= 1; i += 0.01) {
      if (body1.computeContrastRatioAgainst(body2.withLightness(i)) > topContrast) {
        topContrast = body1.computeContrastRatioAgainst(body2.withLightness(i));
        body2 = body2.withLightness(i);
      }

      if (topContrast > 1.1) {
        topContrast = 1;
        break;
      }
    }

    return [body0, body1, body2];
  }

  /// generate body colors ([body0], [body1], & [body2]) for a light themed
  /// color palette

  Future<List<HSLColor>> generateLightBodyColors({
    required HSLColor bodyColor,
    bool isDarkTheme = true,
  }) async {
    var baseColor = bodyColor.withLightness(1);

    body0 = baseColor;

    var topContrast = 1.0;

    for (double i = 1; i >= 0; i -= 0.01) {
      if (baseColor.computeContrastRatioAgainst(body0.withLightness(i)) > topContrast) {
        topContrast = baseColor.computeContrastRatioAgainst(body0.withLightness(i));
        body0 = body0.withLightness(i);
      }

      if (topContrast > 1.1) {
        topContrast = 1;
        break;
      }
    }

    body1 = body0;

    for (double i = body0.lightness; i >= 0; i -= 0.01) {
      if (body0.computeContrastRatioAgainst(body1.withLightness(i)) > topContrast) {
        topContrast = body0.computeContrastRatioAgainst(body1.withLightness(i));
        body1 = body1.withLightness(i);
      }

      if (topContrast > 1.1) {
        topContrast = 1;
        break;
      }
    }

    body2 = body1;

    for (double i = body1.lightness; i >= 0; i -= 0.01) {
      if (body1.computeContrastRatioAgainst(body2.withLightness(i)) > topContrast) {
        topContrast = body1.computeContrastRatioAgainst(body2.withLightness(i));
        body2 = body2.withLightness(i);
      }

      if (topContrast > 1.1) {
        topContrast = 1;
        break;
      }
    }

    return [body0, body1, body2];
  }

  /// generate top color
  ///
  /// ### Note
  /// - to be called only after [generateDarkBodyColors] or [generateLightBodyColors]
  Future<HSLColor> generateTopColor() async {
    // top = topColor;
    // while (!(body2.computeContrastRatioAgainst(top) > 9 &&
    //     body0.computeContrastRatioAgainst(top) > 9)) {
    //   top = top.varyColor();
    // }

    var topContrast = 1.0;
    top = body2;

    for (double i = 0; i < 360; i += 0.1) {
      if (body2.computeContrastRatioAgainst(top.withHue(i)) > topContrast) {
        topContrast = body2.computeContrastRatioAgainst(top.withHue(i));
        top = top.withHue(i);
      }
    }

    for (double i = 0; i <= 1; i += 0.01) {
      if (body2.computeContrastRatioAgainst(top.withSaturation(i)) > topContrast) {
        topContrast = body2.computeContrastRatioAgainst(top.withSaturation(i));
        top = top.withSaturation(i);
      }
    }

    for (double i = 0; i <= 1; i += 0.01) {
      if (body2.computeContrastRatioAgainst(top.withLightness(i)) > topContrast) {
        topContrast = body2.computeContrastRatioAgainst(top.withLightness(i));
        top = top.withLightness(i);
      }
    }

    return top;
  }

  /// generate accent colors ([accentGood] & [accentBad])
  ///
  /// ### Note
  /// - to be called only after [generateDarkBodyColors] or [generateLightBodyColors]
  /// and [generateTopColor]
  Future<List<HSLColor>> generateAccents() async {
    var topMeasure = 1.0;

    accentGood = body2;

    for (double i = 0; i < 360; i += 0.1) {
      var bodyContrast = body2.computeContrastRatioAgainst(accentGood.withHue(i));
      var topContrast = top.computeContrastRatioAgainst(accentGood.withHue(i));

      var measure = (bodyContrast + topContrast) / (bodyContrast - topContrast).abs();

      if (measure > topMeasure) {
        topMeasure = measure;
        accentGood = accentGood.withHue(i);
      }
    }

    for (double i = 0; i <= 1; i += 0.01) {
      var bodyContrast = body2.computeContrastRatioAgainst(accentGood.withSaturation(i));
      var topContrast = top.computeContrastRatioAgainst(accentGood.withSaturation(i));

      var measure = (bodyContrast + topContrast) / (bodyContrast - topContrast).abs();

      if (measure > topMeasure) {
        topMeasure = measure;
        accentGood = accentGood.withSaturation(i);
      }
    }

    for (double i = 0; i <= 1; i += 0.01) {
      var bodyContrast = body2.computeContrastRatioAgainst(accentGood.withLightness(i));
      var topContrast = top.computeContrastRatioAgainst(accentGood.withLightness(i));

      var measure = (bodyContrast + topContrast) / (bodyContrast - topContrast).abs();

      if (measure > topMeasure) {
        topMeasure = measure;
        accentGood = accentGood.withLightness(i);
      }
    }

    topMeasure = 1.0;

    accentBad = body2;

    for (double i = 0; i < 360; i += 0.1) {
      var accentContrast = accentGood.computeContrastRatioAgainst(accentBad.withHue(i));
      var bodyContrast = body2.computeContrastRatioAgainst(accentGood.withHue(i));
      var bodyContrastBase = body0.computeContrastRatioAgainst(accentGood.withHue(i));
      var topContrast = top.computeContrastRatioAgainst(accentGood.withHue(i));

      var contrastList = [accentContrast, bodyContrast, topContrast, bodyContrastBase];

      var measure = ((accentContrast - bodyContrast).abs() +
              (bodyContrast - topContrast).abs() +
              (topContrast - bodyContrastBase).abs() +
              (bodyContrastBase - accentContrast).abs()) /
          (contrastList.reduce(max) - contrastList.reduce(min));

      if (measure > topMeasure) {
        topMeasure = measure;
        accentBad = accentBad.withHue(i);
      }
    }

    for (double i = 0; i <= 1; i += 0.01) {
      var accentContrast = accentGood.computeContrastRatioAgainst(accentBad.withSaturation(i));
      var bodyContrast = body2.computeContrastRatioAgainst(accentGood.withSaturation(i));
      var bodyContrastBase = body0.computeContrastRatioAgainst(accentGood.withSaturation(i));
      var topContrast = top.computeContrastRatioAgainst(accentGood.withSaturation(i));

      var contrastList = [accentContrast, bodyContrast, topContrast, bodyContrastBase];

      var measure = ((accentContrast - bodyContrast).abs() +
              (bodyContrast - topContrast).abs() +
              (topContrast - bodyContrastBase).abs() +
              (bodyContrastBase - accentContrast).abs()) /
          (contrastList.reduce(max) - contrastList.reduce(min));

      if (measure > topMeasure) {
        topMeasure = measure;
        accentBad = accentBad.withSaturation(i);
      }
    }

    for (double i = 0; i <= 1; i += 0.01) {
      var accentContrast = accentGood.computeContrastRatioAgainst(accentBad.withLightness(i));
      var bodyContrast = body2.computeContrastRatioAgainst(accentGood.withLightness(i));
      var bodyContrastBase = body0.computeContrastRatioAgainst(accentGood.withLightness(i));
      var topContrast = top.computeContrastRatioAgainst(accentGood.withLightness(i));

      var contrastList = [accentContrast, bodyContrast, topContrast, bodyContrastBase];

      var measure = ((accentContrast - bodyContrast).abs() +
              (bodyContrast - topContrast).abs() +
              (topContrast - bodyContrastBase).abs() +
              (bodyContrastBase - accentContrast).abs()) /
          (contrastList.reduce(max) - contrastList.reduce(min));

      if (measure > topMeasure) {
        topMeasure = measure;
        accentBad = accentBad.withLightness(i);
      }
    }

    return [accentGood, accentBad];
  }

  @override
  String toString() {
    return 'https://coolors.co/'
        '${body0.toColor().toString().substring(10, 16)}-'
        '${body1.toColor().toString().substring(10, 16)}-'
        '${body2.toColor().toString().substring(10, 16)}-'
        '${accentGood.toColor().toString().substring(10, 16)}-'
        '${accentBad.toColor().toString().substring(10, 16)}-'
        '${top.toColor().toString().substring(10, 16)}';
  }
}
