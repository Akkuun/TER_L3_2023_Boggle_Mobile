import 'package:flutter/material.dart';

class GameStat extends StatelessWidget {
  final double fontSize;
  final String statName;
  final String statValue;
  final double width;
  final Axis orientation;
  final double height;

  const GameStat({
    super.key,
    this.fontSize = 18,
    this.width = 0.25,
    this.height = 0.2,
    this.orientation = Axis.vertical,
    required this.statName,
    required this.statValue,

  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontFamily: 'Jua',
      fontWeight: FontWeight.w400,
    );

    return Container(
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
        width: (orientation == Axis.horizontal) ? MediaQuery.of(context).size.width * width * 1.05 : MediaQuery.of(context).size.width * width,
        height: (orientation == Axis.horizontal) ? MediaQuery.of(context).size.height * height/3 : MediaQuery.of(context).size.width * height,
        child: orientedStats(orientation, statName, statValue, textStyle),
    );
  }
}

Widget orientedStats(Axis orientation, String statName, String statValue, TextStyle textStyle) {
  if (orientation == Axis.horizontal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          statName,
          style: textStyle,
        ),
        Text(
          ' $statValue',
          style: textStyle,
        ),
      ],
    );
  }
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        statName,
        style: textStyle,
      ),
      Text(
        statValue,
        style: textStyle,
      ),
    ],
  );
}