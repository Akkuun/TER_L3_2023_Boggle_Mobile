//components

import 'package:bouggr/pages/game.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wave extends StatelessWidget {
  const Wave({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var opacity = Provider.of<TimerServices>(context).progression;

    return ClipPath(
      clipper: WaveClipper(
        waveHeight: 15,
        waveFrequency: 0.8,
        progression: opacity,
      ),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        height: MediaQuery.of(context).size.height * opacity,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 169, 224, 255),
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height * (1 - opacity),
        ),
      ),
    );
  }
}
