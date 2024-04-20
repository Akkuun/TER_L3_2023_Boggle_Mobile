import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bouggr/components/bottom_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bouggr/components/stat.dart';
import 'package:bouggr/utils/game_data.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late List<String> allResults;
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    const double bottomButtonHeight = 40.0;
    const double titleHeight = 60.0;
    const double paginationButtonsHeight = 50.0;
    final double statContainerHeight = screenHeight -
        appBarHeight -
        bottomButtonHeight -
        titleHeight -
        paginationButtonsHeight;

    return BottomButtons(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              height: titleHeight,
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'St',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 64,
                          fontFamily: 'Jua',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
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
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 64,
                          fontFamily: 'Jua',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Container(
            height: statContainerHeight,
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
            child: FutureBuilder<List<String>>(
              future: _fetchGameResults(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  allResults = snapshot.data!;
                  final currentPageResults = _getCurrentPageResults(allResults);
                  List<Widget> statWidgets = currentPageResults.map((party) {
                    return Stat(
                      key: UniqueKey(),
                      grid: jsonDecode(party)['grid'],
                      statName: 'mot',
                      statValue: jsonDecode(party)['score'].toString(),
                    );
                  }).toList();
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: statWidgets,
                        ),
                      ),
                      _buildPaginationButtons(),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text('No data'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getCurrentPageResults(List<String> allResults) {
    final int startIndex = currentPageIndex * 4;
    final int endIndex = startIndex + 4;
    return allResults.sublist(startIndex, endIndex.clamp(0, allResults.length));
  }

  Widget _buildPaginationButtons() {
    List<Widget> pageButtons = [];

    for (int i = 0; i < _totalPages(); i++) {
      pageButtons.add(
        ElevatedButton(
          onPressed: () {
            setState(() {
              currentPageIndex = i;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              i == currentPageIndex ? const Color(0xFF1F87B3) : Colors.white,
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              i == currentPageIndex ? Colors.white : const Color(0xFF1F87B3),
            ),
          ),
          child: Text((i + 1).toString()),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pageButtons,
    );
  }

  int _totalPages() {
    return (allResults.length / 4).ceil();
  }

  static Future<List<String>> _fetchGameResults() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // récupérer les données depuis Firebase
      return _fetchFirebaseGameResults();
    } else {
      // récupérer les données depuis le stockage local
      return GameDataStorage.loadGameResults();
    }
  }

  static Future<List<String>> _fetchFirebaseGameResults() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final List<String> results = [];
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user_solo_games')
          .doc(user.uid)
          .collection('gameResults')
          .orderBy('score', descending: true) // Tri par score décroissant
          .limit(20)
          .get();

      for (final doc in querySnapshot.docs) {
        results.add(jsonEncode(doc.data()));
      }

      return results;
    } else {
      return [];
    }
  }
}
