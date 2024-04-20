import 'package:flutter/material.dart';

class LeaderboardRow extends StatelessWidget {
  const LeaderboardRow({
    super.key,
    this.rank,
    this.score,
    this.name,
    this.color,
  });

  final int? rank;
  final int? score;
  final String? name;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontFamily: 'Jua',
      fontWeight: FontWeight.w400,
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: Row(
          children: [
            LeaderboardSubContainer(
              width: 24,
              child: Text(
                rank.toString(),
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),
            LeaderboardSubContainer(
              width: 52,
              child: Text(
                score.toString(),
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: LeaderboardSubContainer(
                child: Text(
                  name.toString(),
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderboardSubContainer extends StatelessWidget {
  const LeaderboardSubContainer({
    super.key,
    required this.child,
    this.width = 10,
  });

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 2.0, right: 2.0, top: 4.0, bottom: 4.0),
      child: SizedBox(
        width: width,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
          ),
          child: child,
        ),
      ),
    );
  }
}
