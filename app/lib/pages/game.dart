//globals
import 'package:bouggr/global.dart';

//services
import 'package:bouggr/providers/game.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (widget.mode == GameType.multi) {
      User? user =
          Provider.of<FirebaseAuth>(context, listen: false).currentUser;
      FirebaseFunctions.instance.httpsCallable('LeaveGame').call({
        "userId": user!.uid,
      });
      //Provider.of<RealtimeGameProvider>(_navigator.context, listen: false).onDispose();
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
    final rm = Provider.of<RealtimeGameProvider>(context, listen: false);

    if (Globals.currentMultiplayerGame.isNotEmpty) {
      return Globals.currentMultiplayerGame.split('');
    }
    final database = FirebaseDatabase.instance;
    final gameUID = rm.gameCode;
    final gameRef = database.ref('games/$gameUID');
    final snapshot = await gameRef.child('letters').get();
    final letters = snapshot.value as String;
    var res = List<String>.filled(letters.length, '');
    for (var i = 0; i < letters.length; i++) {
      res[i] = letters[i];
    }
    Globals.currentMultiplayerGame = letters;
    return res;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.mode) {
      case GameType.solo:
        gameServices.gameType = GameType.solo;
        gameServices.letters =
            Globals.selectDiceSet(gameServices.language).roll();
        return Globals(child: Builder(builder: (BuildContext innerContext) {
          return const GameWidget();
        }));
      case GameType.multi:
        final letters = _fetchLetters();
        return Globals(child: Builder(builder: (BuildContext innerContext) {
          return FutureBuilder(
            future: letters,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                gameServices.letters = snapshot.data!;
                gameServices.gameType = GameType.multi;
                return const GameWidget();
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        }));
    }
  }
}
