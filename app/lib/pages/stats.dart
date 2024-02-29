import 'package:bouggr/utils/game_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bouggr/components/bottom_buttons.dart';
import 'package:bouggr/components/stat.dart';

/// Page des stat

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});
  @override
  Widget build(BuildContext context) {
    var parties = GameDataStorage.loadGameResults();

    var isAuth = FirebaseAuth.instance.currentUser != null;

    var filteredParties = parties.then((value) => value
        .where((element) => isAuth
            ? element.uid == FirebaseAuth.instance.currentUser?.uid
            : element.uid == 'guest')
        .toList());

    const textStyleJUA = TextStyle(
      color: Colors.black,
      fontSize: 64,
      fontFamily: 'Jua',
      fontWeight: FontWeight.w400,
      height: 0,
    );
    return BottomButtons(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
            child: const SingleChildScrollView(
              child: Column(
                children: [
                  Stat(
                    statName: 'Nom stat',
                    statValue: '10',
                    isDarker: true,
                    isFirst: true,
                  ),
                  Stat(
                    statName: 'Rang de bouggr sur play store',
                    statValue: '1',
                  ),
                  Stat(
                    statName: 'Nombre de diapos du cours de Meynard',
                    statValue: '386',
                    isDarker: true,
                  ),
                  Stat(
                    statName: 'To-do, remplacer par les vraies stats',
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
