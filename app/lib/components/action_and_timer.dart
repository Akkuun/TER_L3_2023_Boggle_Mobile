//components

import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/timer.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionAndTimer extends StatelessWidget {
  const ActionAndTimer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TimerServices timerServices =
        Provider.of<TimerServices>(context, listen: false);
    GameServices gameServices =
        Provider.of<GameServices>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconBtnBoggle(
          onPressed: () {
            if (gameServices.triggerPopUp) {
              timerServices.stop();
            } else {
              timerServices.start();
            }
            gameServices.toggle(!gameServices.triggerPopUp);
          },
          icon: Icon(
            gameServices.triggerPopUp ? Icons.play_arrow : Icons.pause,
            color: Colors.black,
            size: 48,
            semanticLabel: "pause",
          ),
        ),
        const BoggleTimer(),
        IconBtnBoggle(
          onPressed: () {
            gameServices.stop();
          },
          icon: const Icon(
            Icons.live_help_outlined,
            color: Colors.black,
            size: 48,
            semanticLabel: "pause",
          ),
        ),
      ],
    );
  }
}
