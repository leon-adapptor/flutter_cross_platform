import 'package:cross_platform/platform_widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class PlatformSwitch extends StatelessWidget {
  final bool value;

  final ValueChanged<bool>? onChanged;

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

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
      macOSBuilder: _macOSBuilder,
    );
  }
}
