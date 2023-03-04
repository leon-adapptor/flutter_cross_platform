import 'package:cross_platform/platform_widgets/platform_widget.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class PlatformSlider extends StatelessWidget {
  final double value;

  final ValueChanged<double> onChanged;

  const PlatformSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Slider _androidBuilder(BuildContext context) {
    return Slider(
      value: value,
      onChanged: onChanged,
    );
  }

  CupertinoSlider _iosBuilder(BuildContext context) {
    return CupertinoSlider(
      value: value,
      onChanged: onChanged,
    );
  }

  MacosSlider _macOSBuilder(BuildContext context) {
    return MacosSlider(
      value: value,
      onChanged: onChanged,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _windowsBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: fluent.Slider(
        value: value,
        onChanged: onChanged,
        max: 1.0,
        min: 0.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
      macOSBuilder: _macOSBuilder,
      windowsBuilder: _windowsBuilder,
    );
  }
}
