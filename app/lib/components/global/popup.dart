import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The `PopUp` class is a generic widget that conditionally displays its child widget based on the
/// value of a trigger.
class PopUp<T extends TriggerPopUp> extends StatelessWidget {
  final Widget child;

  const PopUp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    T trigger = context.watch<T>();

    if (trigger.triggerPopUp) {
      return child;
    }

    /// The line `return const SizedBox.shrink();` is returning an empty `SizedBox` widget with zero
    /// width and height. This is used as a placeholder when the `triggerPopUp` value is `false`,
    /// indicating that the child widget should not be displayed.
    return const SizedBox.shrink();
  }
}

/// The `mixin TriggerPopUp on ChangeNotifier` defines a mixin named `TriggerPopUp` that extends the
/// `ChangeNotifier` class.
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
