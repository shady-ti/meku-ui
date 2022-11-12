// {@nodoc}

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:meku/model/colors.dart';

void main(List<String> args) async {
  var hsl0 = const HSLColor.fromAHSL(0, 0, 0.5, 0.3);

  for (double i = 0; i < 361; i += 36) {
    print('H${i.toStringAsFixed(1)}'
        ': ${hsl0.computeContrastRatioAgainst(hsl0.withHue(i))}');
  }

  print('\n\n');

  for (double i = 0; i < 1; i += 0.1) {
    print('L${i.toStringAsFixed(3)}'
        ': ${hsl0.computeContrastRatioAgainst(hsl0.withLightness(i))}');
  }

  print('\n\n');

  for (double i = 0; i < 1; i += 0.1) {
    print('S${i.toStringAsFixed(3)}'
        ': ${hsl0.computeContrastRatioAgainst(hsl0.withSaturation(i))}');
  }

  print('\n\n');

  for (double i = 0; i < 1; i += 0.1) {
    print('H120L${i.toStringAsFixed(3)}'
        ': ${hsl0.computeContrastRatioAgainst(hsl0.withHue(120).withLightness(i))}');
  }

  var hslColor = HSLColor.fromColor(Colors.red);
  var pl = await ColorPalette.generateDarkThemeFrom(bodyColor: hslColor);
  var pd = await ColorPalette.generateLightThemeFrom(bodyColor: hslColor);
  print(pl);
  print(await pl.hasSufficientContrast());
  print(pd);
  print(await pd.hasSufficientContrast());

  // var testDarkPalette = await ColorPalette.generateDarkThemeFrom(
  //   bodyColor: HSLColor.fromColor(const Color.fromARGB(255, 159, 100, 208)),
  //   topColor: HSLHelpers.randomColor(),
  //   accentPositiveColor: HSLColor.fromColor(Color.fromARGB(255, 0, 255, 0)),
  //   accentNegativeColor: HSLColor.fromColor(Color.fromARGB(255, 255, 0, 0)),
  // );

  // print(testDarkPalette);

  // var testLightPalette = await ColorPalette.generateLightThemeFrom(
  //   bodyColor: HSLColor.fromColor(const Color.fromARGB(255, 159, 100, 208)),
  //   topColor: HSLHelpers.randomColor(),
  //   accentPositiveColor: HSLColor.fromColor(Color.fromARGB(255, 0, 255, 0)),
  //   accentNegativeColor: HSLColor.fromColor(Color.fromARGB(255, 255, 0, 0)),
  // );

  // print(testLightPalette);
}

// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         useMaterial3: true,
//         brightness: Brightness.dark,
//         primaryColor: Colors.blueGrey,
//       ),
//       home: ColorPalette(),
//     );
//   }
// }
