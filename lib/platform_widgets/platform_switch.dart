import 'package:cross_platform/platform_widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformSwitch extends StatelessWidget {
  final bool value;

  final ValueChanged<bool>? onChanged;

  const PlatformSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Switch androidBuilder(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
    );
  }

  CupertinoSwitch iosBuilder(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: androidBuilder,
      iosBuilder: iosBuilder,
    );
  }
}
