import 'package:flutter/material.dart';

class GameStat extends StatelessWidget {
  final double fontSize;
  final String statName;
  final String statValue;
  final double width;

  final double height;

  const GameStat({
    super.key,
    this.fontSize = 18,
    this.width = 0.25,
    this.height = 0.2,
    required this.statName,
    required this.statValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        width: MediaQuery.of(context).size.width * width,
        height: MediaQuery.of(context).size.width * height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
      ),
    );
  }
}
