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
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.05,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.lightBlue[isDarker ? 100 : 50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  statName,
                  style: TextStyle(fontSize: fontSize),
                ),
                Text(
                  statValue,
                  style: TextStyle(fontSize: fontSize),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ));
  }
}
