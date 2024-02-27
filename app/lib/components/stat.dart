import 'package:flutter/material.dart';

class Stat extends StatelessWidget {
  final double fontSize;
  final String statName;
  final String statValue;
  final bool isDarker;
  final bool isFirst;
  final bool isLast;

  const Stat({
    super.key,
    this.fontSize = 18,
    this.statName = 'Stat Name',
    this.statValue = 'Stat Value',
    this.isDarker = false,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[isDarker ? 300 : 200],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isFirst ? 8 : 0),
          topRight: Radius.circular(isFirst ? 8 : 0),
          bottomLeft: Radius.circular(isLast ? 8 : 0),
          bottomRight: Radius.circular(isLast ? 8 : 0),
        ),
      ),

      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Flexible(
            child: Text(
              statName,
              style: TextStyle(fontSize: fontSize),
            ),
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
