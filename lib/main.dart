import 'package:cross_platform/color_selector.dart';
import 'package:cross_platform/dashboard.dart';
import 'package:cross_platform/platform_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppStateModel(),
      child: Consumer<AppStateModel>(
        builder: (context, model, child) {
          return MaterialApp(
            title: 'Smart Dash',
            themeMode: model.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: model.colorScheme.lightScheme,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: model.colorScheme.darkScheme,
            ),
            home: const MyHomePage(
              title: 'Smart Dash',
            ),
          );
        },
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

  final List<Widget> _dashWidgets = const [
    DashSlider(label: 'kitchen'),
    DashSlider(label: 'bedroom'),
    DashSlider(label: 'bathroom'),
    DashSlider(label: 'garage'),
    DashSwitch(label: 'basement'),
    DashSwitch(label: 'patio'),
    DashSwitch(label: 'pool'),
    DashSwitch(label: 'front door'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text(title)),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: model.isDarkMode,
                onChanged: (value) {
                  model.darkMode = value;
                },
              ),
              ListTile(
                title: const Text('Theme'),
                trailing: const ColorSelector(),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Platform UI'),
                trailing: const PlatformSelect(),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: Dashboard(
          children: [
            DashSection(label: 'Home', dashControls: _dashWidgets),
            DashSection(label: 'Office', dashControls: _dashWidgets),
          ],
        ),
      ),
    );
  }
}
