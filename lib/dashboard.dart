import 'package:cross_platform/app_state_model.dart';
import 'package:cross_platform/platform_ui.dart';
import 'package:cross_platform/platform_widgets/platform_list_tile.dart';
import 'package:cross_platform/platform_widgets/platform_picker.dart';
import 'package:cross_platform/platform_widgets/platform_slider.dart';
import 'package:cross_platform/platform_widgets/platform_switch.dart';
import 'package:cross_platform/platform_widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'color_selector.dart';

class Dashboard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const Dashboard({super.key, required this.title, required this.children});

  /// This pushes the settings page as a full page modal dialog on top
  /// of the tab bar and everything.
  void _openIosSettings(context) {
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

  /// This is just an arbitrary delay that simulates some network activity.
  Future<void> _refreshData() {
    return Future.delayed(
      const Duration(seconds: 2),
    );
  }

  Widget _androidBuilder(BuildContext context) {
    var breakpoint = 600.0;
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= breakpoint) {
      // large screen layout with expanded drawer
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 240,
              child: Drawer(
                child: SettingsList(title: title),
              ),
            ),
            Expanded(
              child: ListView(
                children: children,
              ),
            ),
          ],
        ),
      );
    } else {
      // small screen layout with collapsed drawer
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        drawer: Drawer(
          child: SettingsList(title: title),
        ),
        body: ListView(
          children: children,
        ),
      );
    }
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
                  (context, index) => children[index],
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

class DashSection extends StatelessWidget {
  final List<Widget> dashControls;

  final String label;

  const DashSection({
    super.key,
    required this.label,
    required this.dashControls,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10,
        bottom: 10,
      ),
      child: Card(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                label,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                bottom: 8,
                left: 8,
                right: 8,
              ),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: dashControls,
            ),
          ],
        ),
      ),
    );
  }
}

class DashControl extends StatelessWidget {
  final double opacity;
  final Widget child;

  const DashControl({
    super.key,
    required this.opacity,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .tertiaryContainer
            .withOpacity(opacity),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class DashSwitch extends StatefulWidget {
  final String label;

  const DashSwitch({
    super.key,
    required this.label,
  });

  @override
  State<DashSwitch> createState() => _DashSwitchState();
}

class _DashSwitchState extends State<DashSwitch> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return DashControl(
      opacity: isSelected ? 1.0 : 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlatformSwitch(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                isSelected = value;
              });
            },
          ),
          Text(widget.label),
        ],
      ),
    );
  }
}

class DashSlider extends StatefulWidget {
  final String label;

  const DashSlider({
    super.key,
    required this.label,
  });

  @override
  State<DashSlider> createState() => _DashSliderState();
}

class _DashSliderState extends State<DashSlider> {
  double sliderValue = 0.0;
  @override
  Widget build(BuildContext context) {
    return DashControl(
      opacity: sliderValue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlatformSlider(
            value: sliderValue,
            onChanged: (value) {
              setState(() {
                sliderValue = value;
              });
            },
          ),
          Text(widget.label),
        ],
      ),
    );
  }
}
