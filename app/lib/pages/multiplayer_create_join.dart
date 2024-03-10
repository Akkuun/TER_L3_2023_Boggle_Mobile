//components

//globals

//services

import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:cloud_functions/cloud_functions.dart';

//utils
import 'package:firebase_auth/firebase_auth.dart';

//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bouggr/components/bottom_buttons.dart';

import '../providers/game.dart';
import '../providers/navigation.dart';
import 'package:bouggr/global.dart';

enum JoinGameReturn {
  success,
  gameFull,
  gameStarted,
  gameNotFound,
  alreadyInGame,
  invalidPassword,
}

class MultiplayerCreateJoinPage extends StatefulWidget {
  const MultiplayerCreateJoinPage({super.key});

  @override
  State<MultiplayerCreateJoinPage> createState() =>
      _MultiplayerCreateJoinPageState();
}

class _MultiplayerCreateJoinPageState extends State<MultiplayerCreateJoinPage> {
  String? _gameUID = '';
  BtnType _btnType = BtnType.secondary;
  int _joinCode = -1;
  String error = '';

  // Leave game

  Future<int> _joinGame(String playerUID) async {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final result =
        await FirebaseFunctions.instance.httpsCallable('JoinGame').call(
      {
        "gameId": _gameUID,
        "userId": playerUID,
        "email": FirebaseAuth.instance.currentUser!.email,
      },
    );
    final response = result.data;
    print("Trting to join game $_gameUID. Return code : $response");
    if (response == JoinGameReturn.success.index) {
      Globals.gameCode = _gameUID!;
      router.goToPage(PageName.multiplayerGame);
    }
    return response;
  }

  _createGame(String playerUID) async {
    try {
      final router = Provider.of<NavigationServices>(context, listen: false);
      final lang = Provider.of<GameServices>(context, listen: false).language;
      final letters = Globals.selectDiceSet(lang).roll();
      final result =
          await FirebaseFunctions.instance.httpsCallable('CreateGame').call(
        {
          "letters": letters.join(''),
          "lang": lang.index,
          "userId": playerUID,
          "email": FirebaseAuth.instance.currentUser!.email,
        },
      );
      final response = result.data as String;
      print("Succesfully created game $response server-side");
      Globals.gameCode = response;
      Globals.currentMultiplayerGame = letters.join('');
      router.goToPage(PageName.multiplayerGame);
    } catch (e) {
      print("ERROR CREATING GAME ? $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Globals.gameCode = '';
    Globals.currentMultiplayerGame = '';
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

    final size = MediaQuery.of(context).size;
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
        SizedBox(height: size.height * 0.05),
        SizedBox(
          width: size.width * 0.8,
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
          onPressed: () async {
            _joinCode = await _joinGame(user!.uid);
            print("Joining game $_gameUID with code $_joinCode");
            if (_joinCode == 0) {
              router.goToPage(PageName.multiplayerGame);
            } else {
              setState(() {
                error =
                    "Error joining game\n${JoinGameReturn.values[_joinCode]}";
              });
            }
          },
          btnSize: BtnSize.large,
          text: "Join a game",
          btnType: _btnType,
        ),
        Text(
          error,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 26,
            fontFamily: 'Jua',
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ));
  }
}
