import 'package:cross_platform/platform_widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformSlider extends PlatformWidget {
  final double value;

  final ValueChanged<double>? onChanged;

  const PlatformSlider(
      {super.key, required this.value, required this.onChanged});
  @override
  Slider createAndroidWidget(BuildContext context) {
    return Slider(value: value, onChanged: onChanged);
  }

  @override
  CupertinoSlider createIosWidget(BuildContext context) {
    return CupertinoSlider(
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
