import 'package:cross_platform/app_state_model.dart';
import 'package:cross_platform/theme/my_color_schemes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorSelector extends StatelessWidget {
  const ColorSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Consumer<AppStateModel>(builder: (context, model, child) {
      var selectedColor = isDarkMode
          ? model.colorScheme.darkScheme.primary
          : model.colorScheme.lightScheme.primary;

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
                  model.colorScheme = scheme;
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
    });
  }
}
