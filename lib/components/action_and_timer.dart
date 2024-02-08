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
    required this.gameServices,
  });

  final GameServices gameServices;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconBtnBoggle(
          onPressed: () {
            if (gameServices.triggerPopUp) {
              Provider.of<TimerServices>(context, listen: false).stop();
            } else {
              Provider.of<TimerServices>(context, listen: false).start();
            }
            Provider.of<GameServices>(context, listen: false)
                .toggle(!gameServices.triggerPopUp);
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
            Provider.of<GameServices>(context, listen: false).stop();
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
