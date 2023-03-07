import 'package:cross_platform/custom_ui/custom_switch.dart';
import 'package:cross_platform/platform_widgets/platform_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class PlatformSwitch extends StatelessWidget {
  final bool value;

  final ValueChanged<bool> onChanged;

  const PlatformSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Switch _androidBuilder(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
    );
  }

  CupertinoSwitch _iosBuilder(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).primaryColor,
    );
  }

  MacosSwitch _macOSBuilder(BuildContext context) {
    return MacosSwitch(
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _windowsBuilder(BuildContext context) {
    return Center(
      child: ToggleSwitch(
        checked: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _customUIBuilder(BuildContext context) {
    return MyCustomSwitch(
      checked: value,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
      macOSBuilder: _macOSBuilder,
      windowsBuilder: _windowsBuilder,
      customUIBuilder: _customUIBuilder,
    );
  }
}
