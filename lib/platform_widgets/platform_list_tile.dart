import 'package:cross_platform/platform_widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformListTile extends StatelessWidget {
  final Widget title;
  final Widget trailing;
  final Function() onTap;

  const PlatformListTile({
    super.key,
    required this.title,
    required this.trailing,
    required this.onTap,
  });

  ListTile _androidBuilder(BuildContext context) {
    return ListTile(
      title: title,
      trailing: trailing,
      onTap: onTap,
    );
  }

  CupertinoListTile _iosBuilder(BuildContext context) {
    return CupertinoListTile(
      title: title,
      trailing: trailing,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }
}
