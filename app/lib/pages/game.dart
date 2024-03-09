//components

import 'dart:math';

import 'package:bouggr/components/grille.dart';

import 'package:bouggr/components/scoreboard.dart';
import 'package:bouggr/components/words_found.dart';
import 'package:bouggr/components/title.dart';

//globals
import 'package:bouggr/global.dart';

//services
import 'package:bouggr/providers/game.dart';

//utils
import 'package:bouggr/providers/timer.dart';

import 'package:bouggr/utils/word_score.dart';
import 'package:bouggr/utils/dico.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/action_and_timer.dart';
import '../components/pop_up_game_menu.dart';

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
  final List<String> _previousWords = [];
  late final List<String> selectedLetter;
  int _score = 0;
  int _strikes = 0;

  late Dictionary _dictionary;

  @override
  void initState() {
    super.initState();
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
    if (_previousWords.contains(word) || !_isWordValid(word)) {
      setState(() {
        _strikes++;
      });
      return false;
    }
    _updateScore(wordScore(word));
    _previousWords.add(word);
    return true;
  }

  bool _endWordSelectionMultiplayer(String word, List<(int, int)> indexes) {
    final gameUID = Globals.gameCode;
    var res = indexes.map((e) => {"x": e.$1, "y": e.$2}).toList();
    print("Word : $res");
    FirebaseFunctions.instance.httpsCallable('sendWord').call({
      "gameId": gameUID,
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "word": res,
    }).then((value) => print("Word $word sent to server"));
    return _endWordSelection(word, indexes);
  }

  int _updateScore(int wordScore) {
    setState(() {
      _score += wordScore;
    });
    return _score;
  }

  List<int> _countWordsByLength() {
    if (_previousWords.isEmpty) {
      return [];
    }
    int max =
        _previousWords.map((e) => e.length).reduce((a, b) => a > b ? a : b);
    List<int> count = List.filled(max - 2, 0);
    for (var word in _previousWords) {
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
        var timerServices = context.watch<TimerServices>();
        return Globals(child: Builder(builder: (BuildContext innerContext) {
          double opacity = timerServices.progression;
          return GameWidget(
            mode: widget.mode,
            opacity: opacity,
            letters: selectedLetter,
            score: _score,
            strikes: _strikes,
            previousWords: _previousWords,
            endWordSelection: _endWordSelection,
            isWordValid: _isWordValid,
            countWordsByLength: _countWordsByLength,
          );
        }));
      case GameType.multi:
        final letters = _fetchLetters();
        return Globals(child: Builder(builder: (BuildContext innerContext) {
          double opacity = 0;
          return FutureBuilder<List<String>>(
            future: letters,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GameWidget(
                  mode: widget.mode,
                  opacity: opacity,
                  letters: snapshot.data!,
                  score: _score,
                  strikes: _strikes,
                  previousWords: _previousWords,
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

class WaveClipper extends CustomClipper<Path> {
  final double waveHeight;
  final double waveFrequency;
  final double progression;

  WaveClipper({this.waveHeight = 20, this.waveFrequency = 1, required this.progression});

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    for (var i = 0; i < size.width; i++) {
      path.lineTo(i.toDouble(), (-waveHeight * sin((i / size.width)*(1+i/(2*size.width)) * 2 * pi * waveFrequency + (progression*pi) + 1.2 * pi) + size.height) - waveHeight);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => true;
}

class GameWidget extends StatelessWidget {
  final GameType mode;
  final double opacity;
  final List<String> letters;
  final int score;
  final int strikes;
  final List<String> previousWords;
  final bool Function(String word, List<(int, int)> indexes)? endWordSelection;
  final bool Function(String word) isWordValid;
  final List<int> Function() countWordsByLength;

  const GameWidget({
    super.key,
    this.mode = GameType.solo,
    this.opacity = 0,
    required this.letters,
    required this.score,
    required this.strikes,
    required this.previousWords,
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
            ClipPath(
              clipper: WaveClipper(
                waveHeight: 15,
                waveFrequency: 0.8,
                progression: opacity,
              ),
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                height: MediaQuery.of(context).size.height * opacity,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height * (1 - opacity),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      const AppTitle(fontSize: 56),
                      ScoreBoard(score: score, strikes: strikes),
                      BoggleGrille(
                        letters: letters,
                        //letters: snapshot.data!,
                        onWordSelectionEnd:
                            endWordSelection ?? (word, indexes) => false,
                        isWordValid: isWordValid,
                      ),
                      WordsFound(previousWords: previousWords),
                      const ActionAndTimer(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        PopUpGameMenu(
          score: score,
          grid: letters.join(),
          words: countWordsByLength(),
        ),
      ],
    );
  }
}
