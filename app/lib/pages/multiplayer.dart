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
//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/action_and_timer.dart';
import '../components/pop_up_game_menu.dart';
import 'package:bouggr/components/bottom_buttons.dart';

class GameMultiplayerPage extends StatefulWidget {
  const GameMultiplayerPage({super.key});

  @override
  State<GameMultiplayerPage> createState() => _GamePageState();
}

class _GamePageState extends State<GameMultiplayerPage> {
  late BoggleGrille boggleGrille;
  final List<String> _previousWords = [];
  int _score = 0;
  int _strikes = 0;

  late Dictionary _dictionary;

  @override
  void initState() {
    super.initState();
    var lang = Provider.of<GameServices>(context, listen: false).language;

    _dictionary = Globals.selectDictionary(lang);
    _dictionary.load();
    List<String> selectedLetter = Globals.selectDiceSet(lang).roll();

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
    return const BottomButtons(child: Text("Multiplayer"));
  }
}
