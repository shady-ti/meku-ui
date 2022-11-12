/// {@nodoc}

// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:meku/model/colors.dart';

enum Status { unlocked, locked }

class ColorPaletteState extends ChangeNotifier {
  final _colors = <Color, Status>{};

  List<Color> get colors => _colors.keys.toList();

  int get colorCount => _colors.length;

  Future<void> addColor(Color color) async {
    if (!_colors.containsKey(color)) _colors[color] = Status.unlocked;

    notifyListeners();
  }

  Future<void> removeColor(Color color) async {
    _colors.remove(color);

    notifyListeners();
  }

  Future<void> replaceColor(Color ogColor, Color newColor) async {
    _colors.remove(ogColor);
    _colors[newColor] = Status.unlocked;

    notifyListeners();
  }

  Future<void> toggleLock(Color color) async {
    _colors[color] = _colors[color] == Status.locked ? Status.unlocked : Status.locked;

    notifyListeners();
  }

  Future<bool> isLocked(Color color) async {
    return _colors[color] == Status.locked;
  }
}

class ColorPalette extends StatefulWidget {
  const ColorPalette({super.key});

  @override
  State<ColorPalette> createState() => _ColorPaletteState();
}

class _ColorPaletteState extends State<ColorPalette> {
  Color improvedColor = Color(0xFF9C27B0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  color: Colors.purple,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  color: Colors.green,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  color: improvedColor,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // setState(() {
            improvedColor = improvedColor.improveContrastAgainst(Color(0xFF4CAF50));
            // });

            print('updated\n');
          },
          icon: const Icon(Icons.shuffle),
        )
      ],
    );
  }
}
