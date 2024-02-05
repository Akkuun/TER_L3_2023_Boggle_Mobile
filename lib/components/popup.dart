import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopUp<T extends TriggerPopUp> extends StatelessWidget {
  final Widget child;

  const PopUp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    T trigger = context.watch<T>();

    if (trigger.triggerPopUp) {
      return child;
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
