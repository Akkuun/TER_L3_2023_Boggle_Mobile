import 'package:flutter/material.dart';

class PlayerInList extends StatelessWidget {
  final double fontSize;
  final Color color;
  final String playerName;
  const PlayerInList({
    super.key,
    this.fontSize = 24,
    this.color = Colors.white,
    this.playerName = "Joueur",
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontFamily: 'Jua',
      fontWeight: FontWeight.w400,
      height: 0,
    );
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(
            playerName,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
