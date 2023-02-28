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
              return OutlinedButton(
                onPressed: () {
                  model.colorScheme = scheme;
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(28, 28),
                  padding: const EdgeInsets.only(right: 18, left: 18),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: color,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: selectedColor == color ? 3 : 0,
                  ),
                  shape: const CircleBorder(),
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
