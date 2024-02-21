import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    super.key,
    required this.score,
    required this.strikes,
  });

  final int score;
  final int strikes;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'rang: 1',
          style: TextStyle(fontSize: 18, color: Colors.blue),
        ),
        const SizedBox(width: 50),
        Text(
          'Score: $score',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        const SizedBox(width: 50),
        Text(
          'Strike: $strikes',
          style: const TextStyle(fontSize: 18, color: Colors.red),
        ),
      ],
    );
  }
}
