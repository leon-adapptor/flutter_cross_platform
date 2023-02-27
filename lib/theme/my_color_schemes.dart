import 'package:flutter/material.dart';
import 'color_schemes_green.dart' as green;
import 'color_schemes_blue.dart' as blue;
import 'color_schemes_red.dart' as red;

class MyColorScheme {
  final String schemeName;
  final ColorScheme lightScheme;
  final ColorScheme darkScheme;
  const MyColorScheme({
    required this.schemeName,
    required this.lightScheme,
    required this.darkScheme,
  });
}

const List<MyColorScheme> myColorSchemes = [
  MyColorScheme(
    schemeName: 'green',
    lightScheme: green.lightColorScheme,
    darkScheme: green.darkColorScheme,
  ),
  MyColorScheme(
    schemeName: 'blue',
    lightScheme: blue.lightColorScheme,
    darkScheme: blue.darkColorScheme,
  ),
  MyColorScheme(
    schemeName: 'red',
    lightScheme: red.lightColorScheme,
    darkScheme: red.darkColorScheme,
  )
];
