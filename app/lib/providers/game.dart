import 'package:bouggr/components/popup.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/providers/realtimegame.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/dico.dart';
import 'package:bouggr/utils/game_data.dart';
import 'package:bouggr/utils/get_all_word.dart';
import 'package:bouggr/utils/player_leaderboard.dart';
import 'package:bouggr/utils/word_score.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

enum GameType { solo, multi }

class GameServices extends ChangeNotifier with TriggerPopUp {
  LangCode? _lang;
  final List<String> _words = [];
  PlayerLeaderboard playerLeaderboard = PlayerLeaderboard();

  int _score = 0;
  GameType? _gameType;
  Map<String, dynamic> multiResult = {};
  int _strikes = 0;
  List<String>? _letters;
  String? _longestWord;
  Coord? _tipsIndex;
  Dictionary? _dictionary;
  List<Coord> validWords = [];

  // Recuper la langue à partir des shared preferences
  Future<void> _initLanguage() async {
    _lang = await GameDataStorage.loadLanguage();
    notifyListeners();
  }

  GameServices() {
    _initLanguage();
  }

  // Récupère la langue actuelle
  LangCode get language {
    return _lang ?? LangCode.FR;
  }

  // Definit la langue actuelle
  void setLanguage(LangCode lang) {
    _lang = lang;
    GameDataStorage.saveLanguage(lang);
    notifyListeners();
  }

  String get longestWord {
    return _longestWord ?? '';
  }

  List<String> get letters {
    return _letters!;
  }

  set letters(List<String> letters) {
    _letters = letters;
  }

  set gameType(GameType gameType) {
    _gameType = gameType;
  }

  void stop() {
    super.toggle(true);
  }

  void leaveGame(BuildContext context, String uid) {
    if (_gameType == GameType.multi) {
      Globals.resetMultiplayerData();
      FirebaseFunctions.instance.httpsCallable('LeaveGame').call({
        "userId": uid,
      });
      Provider.of<RealtimeGameProvider>(context, listen: false).onDispose();
    }
    stop();
    Provider.of<TimerServices>(context, listen: false).resetProgress();
  }

  bool start() {
    super.toggle(false);
    notifyListeners();
    return Globals.selectDictionary(language).dictionary != null;
  }

  int get score {
    return _score;
  }

  List<String> get words {
    return _words;
  }

  bool _isInWordList(String word) {
    return _words.contains(word);
  }

  void _addWord(String word) {
    if (_words.contains(word)) {
      return;
    }
    if (word.length > (_longestWord?.length ?? 0)) {
      _longestWord = word;
    }
    _words.add(word);
    notifyListeners();
  }

  void _addScore(int score) {
    _score += score;
    notifyListeners();
  }

  void addStrike() {
    _strikes++;
    notifyListeners();
  }

  int get strikes {
    return _strikes;
  }

  Coord? get tipsIndex {
    return _tipsIndex;
  }

  void setTipsIndex(Coord index) {
    _tipsIndex = index;
    notifyListeners();
  }

  bool _checkWordSolo(String word) {
    if (_isInWordList(word)) {
      return false;
    }
    if (_dictionary!.contain(word)) {
      _addWord(word);
      _addScore(wordScore(word));
      return true;
    } else {
      addStrike();
      return false;
    }
  }

  Future<bool> _checkWordMulti(Word word) async {
    return FirebaseFunctions.instance.httpsCallable('checkWord').call({
      'word': word.txt,
      'language': language.toString(),
      'gameId': multiResult['gameId'],
      'playerId': multiResult['playerId'],
    }).then((result) {
      if (result.data['result']) {
        _addWord(word.txt);
        _addScore(word.txt.length);
        return true;
      } else {
        addStrike();
        return false;
      }
    });
  }

  /// Fonction qui permet de vérifier si le mot est dans le dictionnaire
  Future<void> chechWord(Word word) async {
    if (_gameType == GameType.solo) {
      if (_checkWordSolo(word.txt)) {
        for (var coord in word.coords) {
          validWords.add(coord);
        }
        Logger().i('validWords: $validWords');
        notifyListeners();

        await Future.delayed(const Duration(seconds: 1), () {
          validWords.clear();
          notifyListeners();
        });
      }
    } else {
      _checkWordMulti(word);
    }
  }

  void loadDictionary() async {
    _dictionary = Globals.selectDictionary(language);
    await _dictionary!.ayncLoad();
  }

  void reset() {
    _tipsIndex = null;
    _score = 0;
    _words.clear();
    _strikes = 0;
    _longestWord = null;
    multiResult = {};
    notifyListeners();
  }

  void checkDetails(BuildContext context) {
    if (_gameType == GameType.multi) {
      Provider.of<NavigationServices>(context, listen: false)
          .goToPage(PageName.detailMulti);
    } else {
      Provider.of<NavigationServices>(context, listen: false)
          .goToPage(PageName.detail);
    }
  }
}
