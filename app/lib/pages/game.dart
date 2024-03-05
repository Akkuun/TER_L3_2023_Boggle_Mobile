//components

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

  bool _endWordSelection(String word, Set<int> indexes) {
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

  bool _endWordSelectionMultiplayer(String word, Set<int> indexes) {
    if(_endWordSelection(word, indexes)) {
      final database = FirebaseDatabase.instance;
      final gameUID = Globals.gameCode;
      final gameRef = database.ref('games/$gameUID');
      final playerUID = FirebaseAuth.instance.currentUser!.uid;
      final playerRef = gameRef.child('players/$playerUID');
      playerRef.child('words').push().set(indexes.toList());
      playerRef.child('score').set(_score);
      return true;
    }
    return false;
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
    final database = FirebaseDatabase.instance;
    final gameUID = Globals.gameCode;
    final gameRef = database.ref('games/$gameUID');
    final snapshot = await gameRef.child('letters').get();
    final letters = snapshot.value as String;
    var res = List<String>.filled(letters.length, '');
    for (var i = 0; i < letters.length; i++) {
      res[i] = letters[i];
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.mode) {
      case GameType.solo:
        var timerServices = context.watch<TimerServices>();
        return Globals(child: Builder(builder: (BuildContext innerContext) {
          double opacity = timerServices.progression;
          return Stack(
            children: [
              Container(
                color: Colors.red.withOpacity(opacity),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        const AppTitle(fontSize: 56),
                        ScoreBoard(score: _score, strikes: _strikes),
                        BoggleGrille(
                          letters: selectedLetter,
                          onWordSelectionEnd: _endWordSelection,
                          isWordValid: _isWordValid,
                          mode: widget.mode,
                        ),
                        WordsFound(previousWords: _previousWords),
                        const ActionAndTimer(),
                      ],
                    ),
                  ),
                ),
              ),
              PopUpGameMenu(
                score: _score,
                grid: selectedLetter.join(),
                words: _countWordsByLength(),
              ),
            ],
          );
        }));
      case GameType.multi:
        final letters = _fetchLetters();
        return Globals(child: Builder(builder: (BuildContext innerContext)
        {
          double opacity = 0;
          return FutureBuilder<List<String>>(
            future: letters,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    Container(
                      color: Colors.red.withOpacity(opacity),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            children: [
                              const AppTitle(fontSize: 56),
                              ScoreBoard(score: _score, strikes: _strikes),
                              BoggleGrille(
                                letters: snapshot.data!,
                                onWordSelectionEnd: _endWordSelectionMultiplayer,
                                isWordValid: _isWordValid,
                              ),
                              WordsFound(previousWords: _previousWords),
                              const ActionAndTimer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    PopUpGameMenu(
                      score: _score,
                      grid: selectedLetter.join(),
                      words: _countWordsByLength(),
                    ),
                  ],
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
  const GameWidget({
    super.key,
    this.mode = GameType.solo,
  });

  @override
  Widget build(BuildContext context) {
    return GamePage(
      mode: mode,
    );
  }
}