import 'package:cross_platform/theme/my_color_schemes.dart';
import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final MyColorScheme selectedColorScheme;
  final Function(String selectedColor) setColorScheme;

  const ColorSelector({
    super.key,
    required this.selectedColorScheme,
    required this.setColorScheme,
  });

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var selectedColor = isDarkMode
        ? selectedColorScheme.darkScheme.primary
        : selectedColorScheme.lightScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...myColorSchemes.map(
          (scheme) {
            var color = isDarkMode
                ? scheme.darkScheme.primary
                : scheme.lightScheme.primary;
            return ElevatedButton(
              onPressed: () {
                setColorScheme(scheme.schemeName);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(color),
                shape: MaterialStateProperty.all<CircleBorder>(
                  CircleBorder(
                    side: BorderSide(
                      color: selectedColor == color
                          ? Theme.of(context).colorScheme.outlineVariant
                          : color,
                      width: 4,
                    ),
                  ),
                ),
              ),
              child: null,
            );
          },
        ),
      ],
    );
  }
}
