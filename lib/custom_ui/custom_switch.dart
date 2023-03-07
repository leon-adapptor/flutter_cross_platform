import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class MyCustomSwitch extends StatelessWidget {
  final bool checked;
  final ValueChanged<bool> onChanged;

  const MyCustomSwitch({
    super.key,
    required this.checked,
    required this.onChanged,
  });

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'button_round_one', // state machine name
      onStateChange: (machineName, stateName) {
        debugPrint('&&&&&&& $machineName state changed to: $stateName');
      },
    );
    if (controller == null) {
      debugPrint('Failed to find controller');
      return;
    }
    artboard.addController(controller);
    SMIBool buttonSelected = controller.findInput<bool>('buttonOn') as SMIBool;
    buttonSelected.value = checked;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: key,
      onTap: () => onChanged(!checked),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black54.withOpacity(0.4),
              spreadRadius: -15,
              blurRadius: 10,
              offset: const Offset(-8, 15),
            ),
          ],
        ),
        child: RiveAnimation.asset(
          key: UniqueKey(),
          artboard: 'button_round_one',
          'assets/smart_home.riv',
          onInit: _onRiveInit,
        ),
      ),
    );
  }
}
