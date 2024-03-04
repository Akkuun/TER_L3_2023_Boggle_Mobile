//components

//globals

//services

import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';

//utils
import 'package:bouggr/providers/timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';


//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bouggr/components/bottom_buttons.dart';

import '../providers/navigation.dart';
import 'package:bouggr/global.dart';

class GameMultiplayerPage extends StatefulWidget {
  const GameMultiplayerPage({super.key});

  @override
  State<GameMultiplayerPage> createState() => _GameMultiplayerPageState();
}

class _GameMultiplayerPageState extends State<GameMultiplayerPage> {
  String? _gameUID = '';
  BtnType _btnType = BtnType.secondary;

  _joinGame(String playerUID) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final database = FirebaseDatabase.instance;
    final gameRef = database.ref('games/$_gameUID');

    gameRef.onValue.listen((event) {


      final gameData = event.snapshot.value as Map<String, dynamic>;
      final players = gameData['players'];
      if (players[playerUID] == null) {
        players[playerUID] = {
          'email': FirebaseAuth.instance.currentUser!.email,
          'score': 0,
          'leader': false,
        };
        gameRef.update({
          'players': players,
        });
        Globals.gameCode = _gameUID!;
        router.goToPage(PageName.game);
      }
    });
  }

  _createGame(String playerUID) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final database = FirebaseDatabase.instance;
    final gameUID = database.ref('games').push().key;
    final gameRef = database.ref('games/$gameUID');
    gameRef.set({
      'players': {
        playerUID: {
          'email': FirebaseAuth.instance.currentUser!.email,
          'score': 0,
          'leader': true,
        }
      },
      'status': 'waiting',
    });
    Globals.gameCode = gameUID!;
    router.goToPage(PageName.game);
  }

  @override
  Widget build(BuildContext context) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        router.goToPage(PageName.login);
      }
    } catch (e) {
      router.goToPage(PageName.login);
    }
    FirebaseDatabase database = FirebaseDatabase.instance;


/*    var playerRef = database.ref('players/$playerUID');
    playerRef.set({
      'email': user!.email,
      'score': 0,
    });*/

    return BottomButtons(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppTitle(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Mul",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Jua',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "ti",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30,
                      fontFamily: 'Jua',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    "player",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Jua',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            BtnBoggle(
              onPressed: () {
                _createGame(user!.uid);
              },
              btnSize: BtnSize.large,
              text: "Create a game",
            ),
            const Text(
              "or",
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontFamily: 'Jua',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _gameUID = value;
                    _btnType = _gameUID!.isNotEmpty ? BtnType.primary : BtnType.secondary;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Game code',
                ),
              ),
            ),
            BtnBoggle(
              onPressed: () {
                _joinGame(user!.uid);
              },
              btnSize: BtnSize.large,
              text: "Join a game",
              btnType: _btnType,
            ),
          ],
        )
    );
  }
}
