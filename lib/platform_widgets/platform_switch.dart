import 'package:cross_platform/platform_widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformSwitch extends PlatformWidget {
  final bool value;

  final ValueChanged<bool>? onChanged;

  const PlatformSwitch(
      {super.key, required this.value, required this.onChanged});
  @override
  Widget createAndroidWidget(BuildContext context) {
    return Switch(value: value, onChanged: onChanged);
  }

  @override
  Widget createIosWidget(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget createLinuxWidget(BuildContext context) {
    // TODO: implement createLinuxWidget
    throw UnimplementedError();
  }

  @override
  Widget createMacOsWidget(BuildContext context) {
    // TODO: implement createMacOsWidget
    throw UnimplementedError();
  }

  @override
  Widget createWebWidget(BuildContext context) {
    // TODO: implement createWebWidget
    throw UnimplementedError();
  }

  @override
  Widget createWindowsWidget(BuildContext context) {
    // TODO: implement createWindowsWidget
    throw UnimplementedError();
  }
}
