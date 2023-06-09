import 'package:cross_platform/app_state_model.dart';
import 'package:cross_platform/platform_ui.dart';
import 'package:cross_platform/platform_widgets/platform_widget.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

/// A multi select widget that renders a platform specific picker.
/// Android: DropdownButton
/// iOS: CupertinoPicker
class PlatformPicker extends StatelessWidget {
  final List<String> items;

  const PlatformPicker({
    super.key,
    required this.items,
  });

  _onChange(String value, AppStateModel model) {
    model.targetUI = value;
    if (value == MyPlatformUI.customUI) {
      model.darkMode = true;
    }
  }

  Widget _androidBuilder(BuildContext context) {
    return Consumer<AppStateModel>(builder: (context, model, child) {
      return DropdownButton<String>(
        value: model.targetUI,
        elevation: 16,
        onChanged: (String? value) {
          _onChange(value ?? MyPlatformUI.auto, model);
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPickerButton(
      items: items,
    );
  }

  Widget _macOSBuilder(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        var popupItems = items.map((String value) {
          return MacosPopupMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
        return MacosPopupButton(
          value: model.targetUI,
          items: popupItems,
          onChanged: (String? value) {
            _onChange(value ?? MyPlatformUI.auto, model);
          },
        );
      },
    );
  }

  Widget _windowsBuilder(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        var popupItems = items.map((String value) {
          return ComboBoxItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
        return ComboBox(
          value: model.targetUI,
          items: popupItems,
          onChanged: (String? value) {
            _onChange(value ?? MyPlatformUI.auto, model);
          },
        );
      },
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

class CupertinoPickerButton extends StatelessWidget {
  final List<String> items;

  const CupertinoPickerButton({super.key, required this.items});

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  Future<String?> _showDialog(context, Widget child) {
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(builder: (context, model, child) {
      return CupertinoButton(
        onPressed: () async {
          model.targetUI = await _showDialog(
                context,
                Consumer<AppStateModel>(builder: (context, model, child) {
                  return NotificationListener<ScrollEndNotification>(
                    onNotification: (notification) {
                      if (notification.metrics is! FixedExtentMetrics) {
                        return false;
                      }

                      final index = (notification.metrics as FixedExtentMetrics)
                          .itemIndex;

                      Navigator.of(context).pop(items[index]);

                      // False allows the event to bubble up further
                      return false;
                    },
                    child: CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: 32,
                      onSelectedItemChanged: (int selectedItem) {},
                      scrollController: FixedExtentScrollController(
                        initialItem: items.indexOf(model.targetUI),
                      ),
                      children:
                          List<Widget>.generate(items.length, (int index) {
                        return Center(
                          child: Text(
                            items[index],
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ) ??
              model.targetUI;

          if (model.targetUI == MyPlatformUI.customUI) {
            model.darkMode = true;
          }
        },
        // This displays the selected item name.
        child: Text(model.targetUI),
      );
    });
  }
}
