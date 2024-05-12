import 'package:bouggr/components/stats_page/post_game_detail.dart';
import 'package:flutter/material.dart';

class Stat extends StatelessWidget {
  final double fontSize;
  final String statName;
  final String statValue;
  final bool isDarker;
  final bool isFirst;
  final bool isLast;
  final String grid;

  const Stat({
    super.key,
    this.fontSize = 18,
    required this.grid,
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
        height: 128,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.lightBlue[isDarker ? 100 : 50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            MiniGrid(grid: grid, height: 102, width: 102),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Score : $statValue',
                  style: TextStyle(
                      fontSize: fontSize, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                PostGameDetail(grid: grid),
                //Text(
                //  statName,
                //  style: TextStyle(
                //      fontScaize: fontSize - 2, fontWeight: FontWeight.bold),
                //),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MiniGrid extends StatelessWidget {
  final String grid;
  final double height;
  final double width;

  const MiniGrid({
    super.key,
    required this.grid,
    this.height = 100,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(48, 108, 164, 1),
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          itemCount: grid.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border:
                    Border.all(color: const Color.fromRGBO(48, 108, 164, 1)),
              ),
              child: Center(
                child: Text(
                  grid[index],
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
