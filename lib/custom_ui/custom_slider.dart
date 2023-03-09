import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class MyCustomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const MyCustomSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  void _onRiveInit2(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'button_rect_one', // state machine name
      onStateChange: (machineName, stateName) {
        debugPrint('&&&&&&& $machineName state changed to: $stateName');
      },
    );
    if (controller == null) {
      debugPrint('Failed to find controller');
      return;
    }
    artboard.addController(controller);
    SMINumber buttonValue =
        controller.findInput<double>('Number 1') as SMINumber;
    buttonValue.value = (value * 5).roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: key,
      onTap: () {
        if (value < 1) {
          onChanged(value + (1 / 5));
        } else {
          onChanged(0);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black54.withOpacity(0.4),
              spreadRadius: -30,
              blurRadius: 30,
              offset: const Offset(-20, 35),
            ),
          ],
        ),
        child: RiveAnimation.asset(
          key: UniqueKey(),
          artboard: 'button_rect_one',
          'assets/smart_home.riv',
          onInit: _onRiveInit2,
        ),
      ),
    );
  }
}
