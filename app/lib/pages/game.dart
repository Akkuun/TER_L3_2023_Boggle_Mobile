//components

//globals
import 'package:bouggr/global.dart';

//services
import 'package:bouggr/providers/game.dart';

import 'package:bouggr/utils/word_score.dart';
import 'package:bouggr/utils/dico.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/game_front.dart';
import '../components/pop_up_game_menu.dart';
import '../components/wave.dart';

class GamePage extends StatefulWidget {
  final List<String>? letters;
  final GameType mode;

  const GamePage({
    super.key,
    this.letters,
    this.mode = GameType.solo,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameServices gameServices;

  late final List<String> selectedLetter;

  late Dictionary _dictionary;

  @override
  void initState() {
    super.initState();
    gameServices = Provider.of<GameServices>(context, listen: false);
    var lang = Provider.of<GameServices>(context, listen: false).language;
    if (widget.letters == null) {
      _dictionary = Globals.selectDictionary(lang);
      _dictionary.load();
      selectedLetter = Globals.selectDiceSet(lang).roll();
    } else {
      selectedLetter = widget.letters!;
    }
  }

  bool _isWordValid(String word) {
    if (word.length < 3) {
      return false;
    }
    return _dictionary.contain(word);
  }

  bool _endWordSelection(String word, List<(int, int)> indexes) {
    if (gameServices.isInWordList(word) || !_isWordValid(word)) {
      gameServices.addStrike();
      return false;
    }
    _updateScore(wordScore(word));
    gameServices.addWord(word);
    return true;
  }

  bool _endWordSelectionMultiplayer(String word, List<(int, int)> indexes) {
    final gameUID = Globals.gameCode;
    var res = indexes.map((e) => {"x": e.$1, "y": e.$2}).toList();
    print("Word : $res");
    FirebaseFunctions.instance.httpsCallable('SendWord').call({
      "gameId": gameUID,
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "word": res,
    }).then((value) => print("Word $word sent to server"));
    return _endWordSelection(word, indexes);
  }

  void _updateScore(int wordScore) {
    gameServices.addScore(wordScore);
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
        return Globals(child: Builder(builder: (BuildContext innerContext) {
          return GameWidget(
            mode: widget.mode,
            letters: selectedLetter,
            endWordSelection: _endWordSelection,
            isWordValid: _isWordValid,
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
                return GameWidget(
                  mode: widget.mode,
                  letters: snapshot.data!,
                  endWordSelection: _endWordSelectionMultiplayer,
                  isWordValid: _isWordValid,
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
  final List<String> letters;

  final bool Function(String word, List<(int, int)> indexes)? endWordSelection;
  final bool Function(String word) isWordValid;
  final List<int> Function() countWordsByLength;

  const GameWidget({
    super.key,
    this.mode = GameType.solo,
    required this.letters,
    this.endWordSelection,
    required this.isWordValid,
    required this.countWordsByLength,
  });

  @override
  Widget build(BuildContext context) {
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
            GameFront(
              letters: letters,
              endWordSelection: endWordSelection,
              isWordValid: isWordValid,
            ),
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
