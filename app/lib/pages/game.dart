//components

//globals
import 'package:bouggr/global.dart';

//services
import 'package:bouggr/providers/game.dart';

import 'package:bouggr/utils/dico.dart';
import 'package:firebase_database/firebase_database.dart';

//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/game_front.dart';
import '../components/pop_up_game_menu.dart';
import '../components/wave.dart';

class GamePage extends StatefulWidget {
  final GameType mode;

  const GamePage({
    super.key,
    this.mode = GameType.solo,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameServices gameServices;

  late final List<String> selectedLetter;

  @override
  void initState() {
    super.initState();
    gameServices = Provider.of<GameServices>(context, listen: false);
  }

  List<int> _countWordsByLength() {
    if (gameServices.words.isEmpty) {
      return [];
    }
    int max =
        gameServices.words.map((e) => e.length).reduce((a, b) => a > b ? a : b);
    List<int> count = List.filled(max - 2, 0);
    for (var word in gameServices.words) {
      count[word.length - 3]++;
    }
    return count;
  }

  Future<List<String>> _fetchLetters() async {
    print("Fetching letters");
    if (Globals.currentMultiplayerGame.isNotEmpty) {
      print(
          "Letters already fetched before : ${Globals.currentMultiplayerGame}");
      return Globals.currentMultiplayerGame.split('');
    }
    print("Fetching letters from firebase");
    final database = FirebaseDatabase.instance;
    final gameUID = Globals.gameCode;
    final gameRef = database.ref('games/$gameUID');
    final snapshot = await gameRef.child('letters').get();
    final letters = snapshot.value as String;
    var res = List<String>.filled(letters.length, '');
    for (var i = 0; i < letters.length; i++) {
      res[i] = letters[i];
    }
    print("Letters fetched : $res");
    Globals.currentMultiplayerGame = letters;
    return res;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.mode) {
      case GameType.solo:
        gameServices.letters =
            Globals.selectDiceSet(gameServices.language).roll();
        return Globals(child: Builder(builder: (BuildContext innerContext) {
          return GameWidget(
            mode: widget.mode,
            countWordsByLength: _countWordsByLength,
          );
        }));
      case GameType.multi:
        final letters = _fetchLetters();
        return Globals(child: Builder(builder: (BuildContext innerContext) {
          return FutureBuilder<List<String>>(
            future: letters,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                gameServices.letters = snapshot.data!;
                return GameWidget(
                  mode: widget.mode,
                  countWordsByLength: _countWordsByLength,
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        }));
    }
  }
}

class GameWidget extends StatelessWidget {
  final GameType mode;

  final List<int> Function() countWordsByLength;

  const GameWidget({
    super.key,
    this.mode = GameType.solo,
    required this.countWordsByLength,
  });

  @override
  Widget build(BuildContext context) {
    final letters = Provider.of<GameServices>(context).letters;
    return Stack(
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: const Color.fromRGBO(255, 237, 172, 1),
            ),
            const Wave(),
            const GameFront(),
          ],
        ),
        PopUpGameMenu(
          grid: letters.join(),
          words: countWordsByLength(),
        ),
      ],
    );
  }
}
