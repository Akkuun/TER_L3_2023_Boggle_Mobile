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
  late BoggleGrille boggleGrille;
  final List<String> _previousWords = [];
  int _score = 0;
  int _strikes = 0;

  late Dictionary _dictionary;

  @override
  void initState() {
    super.initState();
    var lang = Provider.of<GameServices>(context, listen: false).language;
    List<String> selectedLetter;

    switch(widget.mode) {
      case GameType.solo:
        if (widget.letters == null) {
          _dictionary = Globals.selectDictionary(lang);
          _dictionary.load();
          selectedLetter = Globals.selectDiceSet(lang).roll();
        } else {
          selectedLetter = widget.letters!;
        }
        break;
      case GameType.multi:
        User? user;
        try {
          user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            // error
          }
        } catch (e) {
          // error
        }
        final playerUID = user!.uid;
        FirebaseDatabase database = FirebaseDatabase.instance;
        var gameRef = database.ref('games/${Globals.gameCode}');
        var letters = gameRef.child('letters').get();
        print(letters);
        selectedLetter = letters as List<String>;
        break;
    }

    boggleGrille = BoggleGrille(
        letters: selectedLetter,
        onWordSelectionEnd: _endWordSelection,
        isWordValid: _isWordValid);
  }

  bool _isWordValid(String word) {
    if (word.length < 3) {
      return false;
    }
    return _dictionary.contain(word);
  }

  bool _endWordSelection(String word) {
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

  @override
  Widget build(BuildContext context) {
    var timerServices = context.watch<TimerServices>();
    var gameServices = context.watch<GameServices>();
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
                    boggleGrille,
                    WordsFound(previousWords: _previousWords),
                    const ActionAndTimer(),
                    Text(timerServices.seconds.toString()),
                    Text(gameServices.triggerPopUp.toString())
                  ],
                ),
              ),
            ),
          ),
          PopUpGameMenu(
            score: _score,
            grid: boggleGrille.letters.join(),
            words: _countWordsByLength(),
          ),
        ],
      );
    }));
  }
}
