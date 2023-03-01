import 'package:cross_platform/color_selector.dart';
import 'package:cross_platform/dashboard.dart';
import 'package:cross_platform/platform_ui.dart';
import 'package:cross_platform/platform_widgets/platform_list_tile.dart';
import 'package:cross_platform/platform_widgets/platform_picker.dart';
import 'package:cross_platform/platform_widgets/platform_switch.dart';
import 'package:cross_platform/platform_widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String title = 'Smart Dash';

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
        home: MyHomePage(
          title: title,
        ),
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
          home: MyHomePage(
            title: title,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppStateModel>(
      create: (context) => AppStateModel(),
      child: PlatformWidget(
        androidBuilder: _androidBuilder,
        iosBuilder: _iosBuilder,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({
    super.key,
    required this.title,
  });

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
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: Drawer(
        child: SettingsList(title: title),
      ),
      body: Dashboard(
        children: _dashSections,
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(title),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _openIosSettings(context),
              child: const Icon(CupertinoIcons.gear),
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: _refreshData,
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _dashSections[index],
                  childCount: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  void _openIosSettings(context) {
    // This pushes the settings page as a full page modal dialog on top
    // of the tab bar and everything.
    Navigator.of(context, rootNavigator: true).push<void>(
      CupertinoPageRoute(
        title: 'Settings',
        fullscreenDialog: true,
        builder: (context) => CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(),
          child: SafeArea(
            child: SettingsList(title: title),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() {
    return Future.delayed(
      // This is just an arbitrary delay that simulates some network activity.
      const Duration(seconds: 2),
    );
  }
}

/// renders list of settings
class SettingsList extends StatelessWidget {
  const SettingsList({
    super.key,
    required this.title,
  });

  final String title;

  final List<String> list = const <String>[
    MyPlatformUI.auto,
    MyPlatformUI.material,
    MyPlatformUI.cupertino,
    // MyPlatformUI.windows,
    // MyPlatformUI.macOS,
    // MyPlatformUI.linux,
    // MyPlatformUI.web,
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) => ListView(
        padding: EdgeInsets.zero,
        children: [
          model.targetUI == MyPlatformUI.material
              ? DrawerHeader(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                )
              : Container(),
          PlatformListTile(
            title: const Text('Dark Mode'),
            trailing: PlatformSwitch(
              value: model.isDarkMode,
              onChanged: (value) {
                model.darkMode = value;
              },
            ),
            onTap: () {
              model.darkMode = !model.isDarkMode;
            },
          ),
          PlatformListTile(
            title: const Text('Theme'),
            trailing: const ColorSelector(),
            onTap: () {},
          ),
          PlatformListTile(
            title: const Text('Platform UI'),
            trailing: PlatformPicker(items: list),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
