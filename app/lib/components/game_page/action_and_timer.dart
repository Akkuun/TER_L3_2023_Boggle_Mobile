//components

import 'package:bouggr/components/game_page/timer.dart';
import 'package:flutter/material.dart';

import 'pause_action.dart';
import 'tips_action.dart';

class ActionAndTimer extends StatelessWidget {
  const ActionAndTimer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PauseAction(),
        BoggleTimer(),
        TipsAction(),
      ],
    );
  }
}
