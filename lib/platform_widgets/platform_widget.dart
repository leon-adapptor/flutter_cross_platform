import 'dart:io';

import 'package:cross_platform/platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state_model.dart';

abstract class PlatformWidget<
    AndroidWidget extends Widget,
    IosWidget extends Widget,
    MacOSWidget extends Widget,
    WindowsWidget extends Widget,
    LinuxWidget extends Widget,
    WebWidget extends Widget> extends StatelessWidget {
  const PlatformWidget({super.key});

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
          return createAndroidWidget(context);
        } else if (isIOS) {
          return createIosWidget(context);
        } else if (isMacOS) {
          return createMacOsWidget(context);
        } else if (isWindows) {
          return createWindowsWidget(context);
        } else if (isLinux) {
          return createLinuxWidget(context);
        } else if (isWeb) {
          return createWebWidget(context);
        }

        // platform not supported returns an empty widget
        debugPrint('PlatformWidget: Platform not supported');
        return Container();
      },
    );
  }

  AndroidWidget createAndroidWidget(BuildContext context);
  IosWidget createIosWidget(BuildContext context);
  MacOSWidget createMacOsWidget(BuildContext context);
  WindowsWidget createWindowsWidget(BuildContext context);
  LinuxWidget createLinuxWidget(BuildContext context);
  WebWidget createWebWidget(BuildContext context);
}
