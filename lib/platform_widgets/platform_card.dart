import 'package:cross_platform/platform_widgets/platform_widget.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

class PlatformCard extends StatelessWidget {
  final Widget child;

  const PlatformCard({super.key, required this.child});

  Widget _androidBuilder(BuildContext context) {
    return Card(child: child);
  }

  Widget _iosBuilder(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      child: child,
    );
  }

  Widget _macOSBuilder(BuildContext context) {
    return Card(elevation: 0, child: child);
  }

  Widget _windowsBuilder(BuildContext context) {
    return fluent.Card(child: child);
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
