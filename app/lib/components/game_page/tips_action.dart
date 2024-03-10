//components

import 'package:bouggr/components/btn.dart';
import 'package:bouggr/providers/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TipsAction extends StatelessWidget {
  const TipsAction({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    GameServices gameServices =
        Provider.of<GameServices>(context, listen: false);
    return IconBtnBoggle(
      onPressed: () {
        gameServices.stop();
      },
      icon: const Icon(
        Icons.live_help_outlined,
        color: Colors.black,
        size: 48,
        semanticLabel: "pause",
      ),
    );
  }
}
