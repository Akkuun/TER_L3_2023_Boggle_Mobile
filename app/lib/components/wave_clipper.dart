//components

import 'dart:math';
import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  final double waveHeight;
  final double waveFrequency;
  final double progression;

  WaveClipper(
      {this.waveHeight = 20,
      this.waveFrequency = 1,
      required this.progression});

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    for (var i = 0; i < size.width; i++) {
      path.lineTo(
          i.toDouble(),
          (-waveHeight *
                      sin((i / size.width) *
                              (1 + i / (2 * size.width)) *
                              2 *
                              pi *
                              waveFrequency +
                          (progression * pi) +
                          1.2 * pi) +
                  size.height) -
              waveHeight);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => true;
}
