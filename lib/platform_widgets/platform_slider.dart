import 'package:cross_platform/platform_widgets/platform_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
      macOSBuilder: _macOSBuilder,
    );
  }
}
