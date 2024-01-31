import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PupUp<T extends TriggerPopUp> extends StatelessWidget {
  final Widget child;

  const PupUp({super.key, required this.child});

  showDataAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10.0,
            ),
            title: const Text(
              "Create ID",
              style: TextStyle(fontSize: 24.0),
            ),
            content: child,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    T trigger = context.watch<T>();

    if (trigger.triggerPopUp) {
      showAboutDialog(context: context);
    }

    return const SizedBox.shrink();
  }
}

mixin TriggerPopUp on ChangeNotifier {
  bool _trigger = false;

  toggle() {
    _trigger = !_trigger;
    notifyListeners();
  }

  bool get triggerPopUp {
    return _trigger;
  }
}
