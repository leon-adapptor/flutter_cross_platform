import 'dart:io';

import 'package:cross_platform/platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state_model.dart';

/// A simple widget that builds specific widgets for different platforms.
class PlatformWidget extends StatelessWidget {
  const PlatformWidget({
    super.key,
    required this.androidBuilder,
    required this.iosBuilder,
    this.macOSBuilder,
  });

  final WidgetBuilder androidBuilder;
  final WidgetBuilder iosBuilder;
  final WidgetBuilder? macOSBuilder;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        bool auto = model.targetUI == MyPlatformUI.auto;
        bool isAndroid = model.targetUI == MyPlatformUI.material ||
            (auto && Platform.isAndroid);
        bool isIOS = model.targetUI == MyPlatformUI.cupertino ||
            (auto && Platform.isIOS);
        bool isMacOS =
            model.targetUI == MyPlatformUI.macOS || (auto && Platform.isMacOS);
        bool isWindows = model.targetUI == MyPlatformUI.windows ||
            (auto && Platform.isWindows);
        bool isLinux =
            model.targetUI == MyPlatformUI.linux || (auto && Platform.isLinux);
        bool isWeb =
            model.targetUI == MyPlatformUI.web; // || (auto && Platform.web);

        if (isAndroid) {
          return androidBuilder(context);
        } else if (isIOS) {
          return iosBuilder(context);
        } else if (isMacOS) {
          return macOSBuilder != null
              ? macOSBuilder!(context)
              : androidBuilder(context);
          return androidBuilder(context);
        } else if (isWindows) {
          // TODO implement windowsBuilder
          return androidBuilder(context);
        } else if (isLinux) {
          // TODO implement linuxBuilder
          return androidBuilder(context);
        } else if (isWeb) {
          // TODO implement webBuilder
          return androidBuilder(context);
        }

        // platform not supported returns an empty widget
        debugPrint('PlatformWidget: Platform not supported');
        return ErrorWidget('Error Platform not supported');
      },
    );
  }
}
