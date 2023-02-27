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
      body: Dashboard(
        children: [
          DashSection(label: 'Home', dashControls: _dashWidgets),
          DashSection(label: 'Office', dashControls: _dashWidgets),
        ],
      ),
    );
  }
}
