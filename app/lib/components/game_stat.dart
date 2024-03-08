import 'package:flutter/material.dart';

class GameStat extends StatelessWidget {
  final double fontSize;
  final String statName;
  final String statValue;
  final double width;

  const GameStat({
    super.key,
    this.fontSize = 18,
    this.width = 50,
    required this.statName,
    required this.statValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 50,
      child: Column(
        children: [
          Text(
            statName,
            style: TextStyle(fontSize: fontSize),
          ),
          Text(
            statValue,
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
