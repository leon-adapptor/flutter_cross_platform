import 'package:cross_platform/dashboard.dart';
import 'package:cross_platform/platform_widgets/platform_widget.dart';
import 'package:fluent_ui/fluent_ui.dart' hide ThemeData;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

import 'app_state_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String title = 'Smart Dash';

  final List<Widget> _dashSections = const [
    DashSection(
      label: 'Home',
      dashControls: [
        DashSlider(label: 'kitchen'),
        DashSlider(label: 'bedroom'),
        DashSlider(label: 'bathroom'),
        DashSlider(label: 'garage'),
        DashSwitch(label: 'basement'),
        DashSwitch(label: 'patio'),
        DashSwitch(label: 'pool'),
        DashSwitch(label: 'front door'),
      ],
    ),
    DashSection(
      label: 'Office',
      dashControls: [
        DashSlider(label: 'kitchen'),
        DashSlider(label: 'bedroom'),
        DashSlider(label: 'bathroom'),
        DashSlider(label: 'garage'),
        DashSwitch(label: 'basement'),
        DashSwitch(label: 'patio'),
        DashSwitch(label: 'pool'),
        DashSwitch(label: 'front door'),
      ],
    ),
  ];

  Widget _androidBuilder(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) => MaterialApp(
        title: title,
        themeMode: model.themeMode,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: model.colorScheme.lightScheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: model.colorScheme.darkScheme,
        ),
        home: Dashboard(title: title, children: _dashSections),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        var scheme = model.isDarkMode
            ? model.colorScheme.darkScheme
            : model.colorScheme.lightScheme;
        var brightness = model.isDarkMode ? Brightness.dark : Brightness.light;
        return CupertinoApp(
          title: title,
          theme: CupertinoThemeData(
            brightness: brightness,
            primaryColor: scheme.primary,
            primaryContrastingColor: scheme.onPrimary,
            scaffoldBackgroundColor: scheme.background,
            barBackgroundColor: scheme.background,
          ),
          builder: (context, child) {
            // we want to add in the material theme
            // so we can use material widgets
            // and use the material color scheme
            return Theme(
              data: ThemeData(
                useMaterial3: true,
                colorScheme: scheme,
              ),
              child: Material(child: child),
            );
          },
          home: Dashboard(title: title, children: _dashSections),
        );
      },
    );
  }

  Widget _macOSBuilder(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        var brightnessPlatform =
            SchedulerBinding.instance.platformDispatcher.platformBrightness;

        debugPrint('brightness: $brightnessPlatform');

        var scheme = model.isDarkMode
            ? model.colorScheme.darkScheme
            : model.colorScheme.lightScheme;
        var brightness =
            model.isDarkMode ? Brightness.dark : brightnessPlatform;

        return MacosApp(
          title: title,
          theme: MacosThemeData(
            // brightness: brightness,
            primaryColor: scheme.primary,
          ),
          darkTheme: MacosThemeData(
            // brightness: brightness,
            primaryColor: scheme.primary,
          ),
          themeMode: model.themeMode,
          home: Dashboard(title: title, children: _dashSections),
          debugShowCheckedModeBanner: true,
          builder: (context, child) {
            // we want to add in the material theme
            // so we can use material widgets
            // and use the material color scheme
            return Theme(
              data: ThemeData(
                // brightness: brightness,
                useMaterial3: true,
                colorScheme: scheme,
              ),
              child: Material(child: child),
            );
          },
        );
      },
    );
  }

  Widget _windowsBuilder(BuildContext context) {
    return Consumer<AppStateModel>(builder: (context, model, child) {
      var brightnessPlatform =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      var scheme = model.isDarkMode
          ? model.colorScheme.darkScheme
          : model.colorScheme.lightScheme;
      var brightness = model.isDarkMode ? Brightness.dark : brightnessPlatform;
      return FluentApp(
        title: title,
        // TODO styling
        theme: FluentThemeData(),
        home: Dashboard(title: title, children: _dashSections),
        builder: (context, child) {
          // we want to add in the material theme
          // so we can use material widgets
          // and use the material color scheme
          return Theme(
            data: ThemeData(
              // brightness: brightness,
              useMaterial3: true,
              colorScheme: scheme,
            ),
            child: Material(child: child),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppStateModel>(
      create: (context) => AppStateModel(),
      child: PlatformWidget(
        androidBuilder: _androidBuilder,
        iosBuilder: _iosBuilder,
        macOSBuilder: _macOSBuilder,
        windowsBuilder: _windowsBuilder,
      ),
    );
  }
}
