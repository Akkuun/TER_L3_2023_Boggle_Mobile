import 'package:bouggr/components/popup.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/providers/realtimegame.dart';
import 'package:bouggr/providers/timer.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/dico.dart';
import 'package:bouggr/utils/game_data.dart';
import 'package:bouggr/utils/game_result.dart';
import 'package:bouggr/utils/get_all_word.dart';
import 'package:bouggr/utils/player_leaderboard.dart';
import 'package:bouggr/utils/word_score.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  void leaveGame(BuildContext context, String uid, GameResult gameResult) {
    GameDataStorage.saveGameResult(gameResult);
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

  Future<bool> _checkWordMulti(Word word, String gameId) async {
    if (_isInWordList(word.txt)) {
      return false;
    }

    if (_dictionary!.contain(word.txt)) {
      return FirebaseFunctions.instance.httpsCallable('SendWord').call({
        "gameId": gameId,
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "word": word.coords
            .map((e) => {"x": e.y, "y": e.x})
            .toList(), // Coordonnées inversées pour le serveur
      }).then((result) {
        if (result.data == 0) {
          _addWord(word.txt);
          _addScore(word.txt.length);
          return true;
        } else {
          addStrike();
          return false;
        }
      });
    }
    return false;
  }

  /// Fonction qui permet de vérifier si le mot est dans le dictionnaire
  Future<void> chechWord(Word word, String gameId) async {
    if (_gameType == GameType.solo) {
      if (_checkWordSolo(word.txt)) {
        await _displayValid(word);
      }
    } else {
      if (await _checkWordMulti(word, gameId)) {
        await _displayValid(word);
      }
    }
  }

  Future<void> _displayValid(Word word) async {
    for (var coord in word.coords) {
      validWords.add(coord);
    }
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1), () {
      validWords.clear();
      notifyListeners();
    });
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

  /// Go to the detail page of the game
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
