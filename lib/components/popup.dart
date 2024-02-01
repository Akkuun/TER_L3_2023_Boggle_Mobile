import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PupUp<T extends TriggerPopUp> extends StatelessWidget {
  final Widget child;

  const PupUp({super.key, required this.child});
  /*
  Future<void> _showAlert() async {
    return showDialog<void>(
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
            content: child,
          );
        });
  }
*/
  @override
  Widget build(BuildContext context) {
    T trigger = context.watch<T>();

    if (trigger.triggerPopUp) {
      //_showAlert();
    }

    return const SizedBox.shrink();
  }
}

mixin TriggerPopUp on ChangeNotifier {
  bool _trigger = false;

  toggle(bool value) {
    _trigger = value;
    notifyListeners();
  }

  bool get triggerPopUp {
    return _trigger;
  }
}
