import 'package:cross_platform/color_selector.dart';
import 'package:cross_platform/dashboard.dart';
import 'package:cross_platform/theme/my_color_schemes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedScheme = 0;

  void setColorScheme(String schemeName) {
    setState(() {
      selectedScheme = myColorSchemes
          .indexWhere((element) => element.schemeName == schemeName);
    });
  }

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
                colorScheme: myColorSchemes[selectedScheme].lightScheme),
            darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: myColorSchemes[selectedScheme].darkScheme),
            home: MyHomePage(
              title: 'Smart Dash',
              selectedColorScheme: myColorSchemes[selectedScheme],
              setColorScheme: setColorScheme,
            ),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final MyColorScheme selectedColorScheme;
  final Function(String selectedColor) setColorScheme;

  const MyHomePage({
    super.key,
    required this.title,
    required this.setColorScheme,
    required this.selectedColorScheme,
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
                trailing: ColorSelector(
                  selectedColorScheme: selectedColorScheme,
                  setColorScheme: setColorScheme,
                ),
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

class PlatformSelect extends StatefulWidget {
  const PlatformSelect({super.key});

  @override
  State<PlatformSelect> createState() => _PlatformSelectState();
}

class _PlatformSelectState extends State<PlatformSelect> {
  final List<String> list = <String>[
    'Auto',
    'Material',
    'Cupertino',
    'Windows',
    'MacOS',
    'Linux',
    'Web',
  ];

  late String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 16,
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
