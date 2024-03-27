import 'dart:convert';

import 'package:bouggr/utils/game_data.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/components/bottom_buttons.dart';
import 'package:bouggr/components/stat.dart';

/// Page des stat

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});
  @override
  Widget build(BuildContext context) {
    var parties = GameDataStorage.loadGameResults();

    const textStyleJUA = TextStyle(
      color: Colors.black,
      fontSize: 64,
      fontFamily: 'Jua',
      fontWeight: FontWeight.w400,
      height: 0,
    );
    return BottomButtons(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      const Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: 430,
          height: 70,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'St',
                  style: textStyleJUA,
                ),
                TextSpan(
                  text: 'a',
                  style: TextStyle(
                    color: Color(0xFF1F87B3),
                    fontSize: 64,
                    fontFamily: 'Jua',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                TextSpan(
                  text: 'ts',
                  style: textStyleJUA,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
            child: Builder(builder: (BuildContext innerContext) {
          return FutureBuilder(
            future: parties,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.hasData) {
                var parties = snapshot.data;

                return Column(
                  children: [
                    for (var party in parties)
                      Stat(
                        statName: "test",
                        statValue: jsonDecode(party)['score'].toString(),
                      )
                  ],
                );
              }
              return const Text('No data');
            },
          );
        })),
      )
    ]));
  }
}
