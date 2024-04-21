//components

//globals

//services

import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/realtimegame.dart';
import 'package:bouggr/utils/decode.dart';
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
  wrongGameId,
}

class MultiplayerCreateJoinPage extends StatefulWidget {
  const MultiplayerCreateJoinPage({super.key});

  @override
  State<MultiplayerCreateJoinPage> createState() =>
      _MultiplayerCreateJoinPageState();
}

class _MultiplayerCreateJoinPageState extends State<MultiplayerCreateJoinPage> {
  // Leave game
  BtnType _btnType = BtnType.secondary;
  String error = '';

  Future<int> _joinGame(String playerUID, RealtimeGameProvider rm,
      NavigationServices router, User? user) async {
    var result =
        await FirebaseFunctions.instance.httpsCallable('JoinGame').call(
      {
        "gameId": rm.gameCode,
        "userId": playerUID,
        "email": user?.email ?? "",
        "name": user?.email ?? "",
      },
    );
    var response = result.data;
    print("Trting to join game ${rm.gameCode} . Return code : $response");
    if (response["error"] != null) {
      print("${response["error"]}. Trying to leave it and join again");
      result = await FirebaseFunctions.instance.httpsCallable('JoinGame').call(
        {
          "gameId": rm.gameCode,
          "userId": playerUID,
          "email": user?.email ?? "",
          "name": user?.email ?? "",
        },
      );
      response = result.data;
    }
    if (response == JoinGameReturn.success.index) {
      rm.gameCode = rm.gameCode;
      router.goToPage(PageName.multiplayerGameWait);
    }
    return (response as Map<String, dynamic>)["code"];
  }

  _createGame(String playerUID, User? user, RealtimeGameProvider rm,
      NavigationServices router, LangCode lang) async {
    final letters = Globals.selectDiceSet(lang).roll();
    final result =
        await FirebaseFunctions.instance.httpsCallable('CreateGame').call(
      {
        "letters": letters.join(''),
        "lang": lang.index,
        "userId": playerUID,
        "email": user?.email ?? "",
        "name": user?.email ?? "",
      },
    );

    if (result.data == null) {
      print("Error creating game : response is null");
      return;
    }

    final response = result.data as Map<String, dynamic>;
    if (response["error"] != null) {
      print("Error creating game : ${response["error"]}");
      return;
    }

    // print response
    print("Response : $response");
    print("Succesfully created game $response server-side");
    if (response["gameId"] == null) {
      print("${response["error"]}. Trying to leave it and create a new one");
      FirebaseFunctions.instance.httpsCallable('LeaveGame').call({
        "userId": playerUID,
      }).then((value) {
        //should not be recursive
        print("Left game, $value");
      });
      return;
    }
    if (response["error"] != null) {
      print("Error creating game : ${response["error"]}");
      return;
    }
    rm.gameCode = response['gameId'];
    Globals.currentMultiplayerGame = letters.join('');
    router.goToPage(PageName.multiplayerGameWait);
  }

  @override
  Widget build(BuildContext context) {
    Globals.resetMultiplayerData();
    final fireAuth = Provider.of<FirebaseAuth>(context, listen: false);
    final rm = Provider.of<RealtimeGameProvider>(context, listen: false);
    final router = Provider.of<NavigationServices>(context, listen: false);
    User? user = fireAuth.currentUser;
    if (user == null) {
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
          onPressed: () async {
            if (user == null) {
              router.goToPage(PageName.login);
              return;
            }
            await _createGame(user.uid, fireAuth.currentUser, rm, router,
                Provider.of<GameServices>(context, listen: false).language);
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
              if (value.isEmpty) {
                setState(() {
                  _btnType = BtnType.secondary;
                });
                return;
              }
              rm.gameCode = value;
              setState(() {
                _btnType = BtnType.primary;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Game code',
            ),
          ),
        ),
        BtnBoggle(
          onPressed: () async {
            var joinCode = await _joinGame(user!.uid, rm, router, user);
            print("Joining game ${rm.gameCode} with code $joinCode");
            if (joinCode == 0) {
              if (rm.gameCode == '') {
                print("Error joining game : game code is null");
                return;
              }

              router.goToPage(PageName.multiplayerGameWait);
            } else {
              setState(() {
                error =
                    "Error joining game\n${JoinGameReturn.values[joinCode]}";
                FocusScope.of(context)
                    .unfocus(); //force la fermeture du clavier
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
