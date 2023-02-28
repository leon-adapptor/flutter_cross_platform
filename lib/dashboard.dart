import 'package:cross_platform/platform_widgets/platform_slider.dart';
import 'package:cross_platform/platform_widgets/platform_switch.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final List<Widget> children;

  const Dashboard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children,
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
      padding: const EdgeInsets.all(10.0),
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
