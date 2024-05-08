//components

import 'package:bouggr/components/game_page/only_multi/timer_multi.dart';
import 'package:bouggr/components/game_page/timer.dart';
import 'package:flutter/material.dart';

import 'pause_action.dart';
import 'tips_action.dart';

class ActionAndTimer extends StatelessWidget {
  final bool isMulti;
  const ActionAndTimer({
    super.key,
    this.isMulti = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const PauseAction(),
        isMulti ? const BoggleTimerMulti() : const BoggleTimer(),
        const TipsAction(),
      ],
    );
  }
}
