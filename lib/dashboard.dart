import 'package:cross_platform/app_state_model.dart';
import 'package:cross_platform/archery_page.dart';
import 'package:cross_platform/platform_ui.dart';
import 'package:cross_platform/platform_widgets/platform_card.dart';
import 'package:cross_platform/platform_widgets/platform_list_tile.dart';
import 'package:cross_platform/platform_widgets/platform_picker.dart';
import 'package:cross_platform/platform_widgets/platform_slider.dart';
import 'package:cross_platform/platform_widgets/platform_switch.dart';
import 'package:cross_platform/platform_widgets/platform_widget.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

import 'color_selector.dart';

class Dashboard extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const Dashboard({super.key, required this.title, required this.children});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _pageIndex = 0;

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
            child: SettingsList(title: widget.title),
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
        appBar: AppBar(title: Text(widget.title)),
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 240,
              child: Drawer(
                child: SettingsList(title: widget.title),
              ),
            ),
            Expanded(
              child: ListView(
                children: widget.children,
              ),
            ),
          ],
        ),
      );
    } else {
      // small screen layout with collapsed drawer
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        drawer: Drawer(
          child: SettingsList(title: widget.title),
        ),
        body: ListView(
          children: widget.children,
        ),
        // launch archery pull to refresh demo
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.double_arrow_sharp),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ArcheryPage()),
          ),
        ),
      );
    }
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(widget.title),
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
                  (context, index) => widget.children[index],
                  childCount: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _macOSBuilder(BuildContext context) {
    return PlatformMenuBar(
      menus: [
        PlatformMenu(label: widget.title, menus: [
          const PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.about,
          ),
          PlatformMenuItem(
            label: 'Preferences...',
            onSelected: () => showMacosSheet(
              context: context,
              barrierDismissible: true,
              builder: (_) =>
                  MacosSheet(child: SettingsList(title: widget.title)),
            ),
          ),
          const PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.quit,
          ),
        ]),
      ],
      child: MacosWindow(
        sidebar: Sidebar(
          minWidth: 200,
          // dragClosed: true,
          builder: (context, scrollController) => SidebarItems(
            currentIndex: _pageIndex,
            onChanged: (index) {
              setState(() => _pageIndex = index);
            },
            items: const [
              SidebarItem(
                leading: MacosIcon(CupertinoIcons.home),
                label: Text('Dashboard'),
              ),
              // SidebarItem(
              //   leading: MacosIcon(CupertinoIcons.info_circle),
              //   label: Text('About'),
              // ),
            ],
          ),
          bottom: MacosListTile(
            leading: const MacosIcon(CupertinoIcons.gear),
            title: const Text('Settings'),
            onClick: () {
              showMacosSheet(
                context: context,
                barrierDismissible: true,
                builder: (_) =>
                    MacosSheet(child: SettingsList(title: widget.title)),
              );
            },
          ),
        ),
        child: ContentArea(
          builder: (BuildContext context, ScrollController scrollController) =>
              IndexedStack(
            index: _pageIndex,
            children: [
              Container(
                key: UniqueKey(),
                child: ListView(children: widget.children),
              ),
              // AboutPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _windowsBuilder(BuildContext context) {
    return fluent.NavigationView(
      appBar: fluent.NavigationAppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      pane: fluent.NavigationPane(
          displayMode: fluent.PaneDisplayMode.auto,
          selected: _pageIndex,
          onChanged: (value) => setState(() {
                _pageIndex = value;
              }),
          items: [
            fluent.PaneItem(
              icon: const Icon(fluent.FluentIcons.home),
              title: const Text("Home"),
              body: ListView(
                children: widget.children.take(1).toList(),
              ),
            ),
            fluent.PaneItem(
              icon: const Icon(fluent.FluentIcons.waffle_office365),
              title: const Text("Office"),
              body: ListView(
                children: widget.children.skip(1).toList(),
              ),
            ),
          ],
          footerItems: [
            fluent.PaneItem(
              icon: const Icon(fluent.FluentIcons.settings),
              title: const Text("Settings"),
              body: SettingsList(title: widget.title),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
      macOSBuilder: _macOSBuilder,
      windowsBuilder: _windowsBuilder,
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
    // MyPlatformUI.material3,
    MyPlatformUI.cupertino,
    MyPlatformUI.macOS,
    MyPlatformUI.windows,
    // MyPlatformUI.linux,
    // MyPlatformUI.web,
    MyPlatformUI.customUI,
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) => ListView(
        padding: EdgeInsets.zero,
        children: [
          model.targetUI == MyPlatformUI.material ||
                  model.targetUI == MyPlatformUI.customUI
              ? DrawerHeader(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                )
              : Container(),
          PlatformListTile(
            title: const Text('Dark Mode'),
            trailing: SizedBox(
              width: 60,
              height: 60,
              child: PlatformSwitch(
                value: model.isDarkMode,
                onChanged: (value) {
                  model.darkMode = value;
                },
              ),
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
      child: PlatformCard(
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

class PlatformDashControl extends StatelessWidget {
  final String label;
  final double opacity;
  final Widget control;

  const PlatformDashControl({
    super.key,
    required this.label,
    required this.opacity,
    required this.control,
  });

  Widget _androidBuilder(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .tertiaryContainer
            .withOpacity(opacity),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(flex: 4, child: control),
          Expanded(flex: 1, child: Text(label)),
        ],
      ),
    );
  }

  Widget _customUIBuilder(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(flex: 4, child: control),
        Expanded(flex: 1, child: Text(label)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      customUIBuilder: _customUIBuilder,
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
    return PlatformDashControl(
      label: widget.label,
      opacity: isSelected ? 1.0 : 0.0,
      control: PlatformSwitch(
        value: isSelected,
        onChanged: (value) {
          setState(() {
            isSelected = value;
          });
        },
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
    return PlatformDashControl(
      label: widget.label,
      opacity: sliderValue,
      control: PlatformSlider(
        value: sliderValue,
        onChanged: (value) {
          setState(() {
            sliderValue = value;
          });
        },
      ),
    );
  }
}
