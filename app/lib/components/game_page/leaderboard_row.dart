import 'package:bouggr/providers/game.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/components/game_stat.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/global.dart';

class LeaderboardRow extends StatelessWidget {
  const LeaderboardRow({
    super.key,
    this.rank,
    this.score,
    this.name,
  });

  final int? rank;
  final int? score;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
