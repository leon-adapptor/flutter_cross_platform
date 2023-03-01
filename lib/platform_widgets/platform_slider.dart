import 'package:cross_platform/platform_widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformSlider extends StatelessWidget {
  final double value;

  final ValueChanged<double>? onChanged;

  const PlatformSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Slider androidBuilder(BuildContext context) {
    return Slider(
      value: value,
      onChanged: onChanged,
    );
  }

  CupertinoSlider iosBuilder(BuildContext context) {
    return CupertinoSlider(
      value: value,
      onChanged: onChanged,
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
