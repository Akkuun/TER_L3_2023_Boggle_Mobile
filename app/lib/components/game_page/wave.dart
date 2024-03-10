//components

import 'package:bouggr/providers/timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'wave_clipper.dart';

class Wave extends StatelessWidget {
  const Wave({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var progression = Provider.of<TimerServices>(context).progression;

    var h = MediaQuery.of(context).size.height;
    return ClipPath(
      clipper: WaveClipper(
        progression: progression,
      ),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        height: h * progression,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 169, 224, 255),
        constraints: BoxConstraints.expand(
          height: h * (1 - progression),
        ),
      ),
    );
  }
}
