//components

//globals

//services

import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/pages/page_name.dart';

//utils
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bouggr/components/bottom_buttons.dart';

import '../providers/game.dart';
import '../providers/navigation.dart';
import 'package:bouggr/global.dart';

class MultiplayerCreateJoinPage extends StatefulWidget {
  const MultiplayerCreateJoinPage({super.key});

  @override
  State<MultiplayerCreateJoinPage> createState() => _MultiplayerCreateJoinPageState();
}

class _MultiplayerCreateJoinPageState extends State<MultiplayerCreateJoinPage> {
  String? _gameUID = '';
  BtnType _btnType = BtnType.secondary;
  bool _incorrectCode = false;

  Future<bool> _joinGame(String playerUID) async {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final database = FirebaseDatabase.instance;
    final gameRef = database.ref('games/$_gameUID');
    final gameData = await gameRef.child('players').get();
    if (gameData.exists) {
      final players = gameData.value;

      if (players != null) {
        gameRef.child('players/$playerUID').set({
          'email': FirebaseAuth.instance.currentUser!.email,
          'score': 0,
          'leader': false,
        });
      }
      Globals.gameCode = _gameUID!;
      router.goToPage(PageName.game);
      return true;
    } else {
      return false;
    }
  }

  _createGame(String playerUID) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final database = FirebaseDatabase.instance;
    final gameUID = database.ref('games').push().key;
    final gameRef = database.ref('games/$gameUID');
    var lang = Provider.of<GameServices>(context, listen: false).language;
    var letters = Globals.selectDiceSet(lang).roll();

    print(letters);
    gameRef.set({
      'players': {
        playerUID: {
          'email': FirebaseAuth.instance.currentUser!.email,
          'score': 0,
          'leader': true,
        }
      },
      'status': 'waiting',
      'lang': lang.toString(),
      'letters': letters,
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
                _btnType =
                    _gameUID!.isNotEmpty ? BtnType.primary : BtnType.secondary;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Game code',
            ),
          ),
        ),
        BtnBoggle(
          onPressed: () {
            if (_gameUID!.isNotEmpty) {
              _joinGame(user!.uid).then((value) {
                if (value != _incorrectCode) {
                  setState(() {
                    _incorrectCode = value;
                  });
                }
              });
            }
          },
          btnSize: BtnSize.large,
          text: "Join a game",
          btnType: _btnType,
        ),
        if (_incorrectCode)
          const Text(
            "Incorrect code",
            style: TextStyle(
              color: Colors.red,
              fontSize: 26,
              fontFamily: 'Jua',
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    ));
  }
}
