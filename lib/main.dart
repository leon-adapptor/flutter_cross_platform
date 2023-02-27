import 'package:cross_platform/dashboard.dart';
import 'package:flutter/material.dart';
import './theme/color_schemes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Dash',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const MyHomePage(title: 'Smart Dash'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

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
    return Scaffold(
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
              value: false,
              onChanged: (value) {},
            ),
            ListTile(
              title: const Text('Theme Color'),
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
