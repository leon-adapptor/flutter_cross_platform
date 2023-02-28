import 'package:cross_platform/app_state_model.dart';
import 'package:cross_platform/platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlatformSelect extends StatelessWidget {
  const PlatformSelect({super.key});

  final List<String> list = const <String>[
    MyPlatformUI.auto,
    MyPlatformUI.material,
    MyPlatformUI.cupertino,
    // MyPlatformUI.windows,
    // MyPlatformUI.macOS,
    // MyPlatformUI.linux,
    // MyPlatformUI.web,
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(builder: (context, model, child) {
      return DropdownButton<String>(
        value: model.targetUI,
        elevation: 16,
        onChanged: (String? value) {
          model.targetUI = value!;
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }
}
