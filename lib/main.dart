import 'package:flutter/material.dart';
import 'package:meku/ui/color_palette.dart';

void main(List<String> args) {
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
      ),
      home: ColorPalette(),
    );
  }
}
