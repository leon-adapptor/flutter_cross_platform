import 'dart:io';

import 'package:cross_platform/platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state_model.dart';

/// A widget that takes platform specific [WidgetBuilder] functions and
/// runs the builder fucntion based on the selected or detected platform.
///
/// androidBuilder is the only required prop, and is used by default if no
/// platform-specific builder is provided.
class PlatformWidget extends StatelessWidget {
  const PlatformWidget({
    super.key,
    required this.androidBuilder,
    this.iosBuilder,
    this.macOSBuilder,
    this.windowsBuilder,
    this.customUIBuilder,
  });

  final WidgetBuilder androidBuilder;
  final WidgetBuilder? iosBuilder;
  final WidgetBuilder? macOSBuilder;
  final WidgetBuilder? windowsBuilder;
  final WidgetBuilder? customUIBuilder;

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
        bool isCustomUI = model.targetUI == MyPlatformUI.customUI;

        if (isAndroid) {
          return androidBuilder(context);
        } else if (isIOS) {
          return iosBuilder != null
              ? iosBuilder!(context)
              : androidBuilder(context);
        } else if (isMacOS) {
          return macOSBuilder != null
              ? macOSBuilder!(context)
              : androidBuilder(context);
        } else if (isWindows) {
          return windowsBuilder != null
              ? windowsBuilder!(context)
              : androidBuilder(context);
        } else if (isCustomUI) {
          return customUIBuilder != null
              ? customUIBuilder!(context)
              : androidBuilder(context);
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
