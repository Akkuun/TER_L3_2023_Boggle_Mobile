//globals
import 'package:bouggr/global.dart';

//services
import 'package:bouggr/providers/game.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/game_page/game_widget.dart';
import '../providers/realtimegame.dart';

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

  @override
  void dispose() {
    if (widget.mode == GameType.multi) {
      User? user = FirebaseAuth.instance.currentUser;
      FirebaseFunctions.instance.httpsCallable('LeaveGame').call({"userId": user!.uid,});
      Provider.of<RealtimeGameProvider>(context, listen: false).onDispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    gameServices = Provider.of<GameServices>(context, listen: false);
    if (widget.mode == GameType.multi) {
      Provider.of<RealtimeGameProvider>(context, listen: false).initListeners();
    }
  }

  Future<List<String>> _fetchLetters() async {
    if (kDebugMode) {
      print("Fetching letters");
    }
    if (Globals.currentMultiplayerGame.isNotEmpty) {
      if (kDebugMode) {
        print(
            "Letters already fetched before : ${Globals.currentMultiplayerGame}");
      }
      return Globals.currentMultiplayerGame.split('');
    }
    if (kDebugMode) {
      print("Fetching letters from firebase");
    }
    final database = FirebaseDatabase.instance;
    final gameUID = Globals.gameCode;
    final gameRef = database.ref('games/$gameUID');
    final snapshot = await gameRef.child('letters').get();
    final letters = snapshot.value as String;
    var res = List<String>.filled(letters.length, '');
    for (var i = 0; i < letters.length; i++) {
      res[i] = letters[i];
    }
    if (kDebugMode) {
      print("Letters fetched : $res");
    }
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
          return const GameWidget(gameType: GameType.solo);
        }));
      case GameType.multi:
        final data = context.watch<RealtimeGameProvider>().players;
        print("data : $data");
        print("type : ${data.runtimeType}");
        final letters = _fetchLetters();
        return Globals(child: Builder(builder: (BuildContext innerContext) {
          return FutureBuilder<List<String>>(
            future: letters,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                gameServices.letters = snapshot.data!;
                return GameWidget(gameType: GameType.multi, players : data);
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        }));
    }
  }
}
