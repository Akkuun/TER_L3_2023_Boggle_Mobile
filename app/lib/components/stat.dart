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
    required this.statName,
    this.statValue = 'N/A',
    this.isDarker = false,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.lightBlue[isDarker ? 100 : 50],
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                statName,
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              statValue,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
