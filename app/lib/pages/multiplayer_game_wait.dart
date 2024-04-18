//globals
import 'dart:convert';

import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/player_in_list.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/pages/page_name.dart';

//services
import 'package:bouggr/providers/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

//flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/game_page/game_widget.dart';
import '../components/title.dart';
import '../providers/navigation.dart';
import '../providers/realtimegame.dart';

class GameWaitPage extends StatefulWidget {
  final GameType mode;

  const GameWaitPage({
    super.key,
    this.mode = GameType.solo,
  });

  @override
  State<GameWaitPage> createState() => _GameWaitPageState();
}

class _GameWaitPageState extends State<GameWaitPage> {
  late GameServices gameServices;
  late ListView playerList;

  @override
  void initState() {
    super.initState();
    gameServices = Provider.of<GameServices>(context, listen: false);
    Provider.of<RealtimeGameProvider>(context, listen: false).initListeners();
  }

  @override
  void dispose() {
    Provider.of<RealtimeGameProvider>(context, listen: false).onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Game code : ${Globals.gameCode}");
    final data = context.watch<RealtimeGameProvider>().players;
    final gameStatus = context.watch<RealtimeGameProvider>().gameStatus;
    if (gameStatus == 0) {
      final router = Provider.of<NavigationServices>(context, listen: false);
      router.goToPage(PageName.multiplayerGame);
    }
    TextStyle textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontFamily: 'Jua',
      fontWeight: FontWeight.w400,
    );

    User? user;
    final router = Provider.of<NavigationServices>(context, listen: false);
    try {
      user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        router.goToPage(PageName.login);
      }
    } catch (e) {
      router.goToPage(PageName.login);
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 32),
            child: AppTitle(),
          ),
          Text(
          "Joueurs présents :",
          style: textStyle,
          textAlign: TextAlign.center,
          ),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color:  Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromARGB(255, 89, 150, 194),
                      width: 1,
                    ),
                    boxShadow: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),],
                  ),
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      try {
                        return PlayerInList(
                          playerName: data.elementAt(index).value["name"],
                          color: index % 2 == 0
                              ? const Color.fromARGB(255, 89, 150, 194)
                              : const Color.fromARGB(255, 181, 224, 255),
                        );
                      } catch (e) {
                        return PlayerInList(
                          playerName: "Joueur",
                          color: index % 2 == 0
                              ? const Color.fromARGB(255, 89, 150, 194)
                              : const Color.fromARGB(255, 181, 224, 255),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          BtnBoggle(
            // Start game
            onPressed: () async {
              final rep = await FirebaseFunctions.instance.httpsCallable('StartGame').call({
                "gameId": Globals.gameCode,
                "userId": user!.uid,
              });
              int? code = rep.data;
              if (code == 0) {
                router.goToPage(PageName.multiplayerGame);
              }
            },
            text: Globals.getText(gameServices.language, 63),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: BtnBoggle(
              // Leave game
              onPressed: () {
                FirebaseFunctions.instance.httpsCallable('LeaveGame').call({
                  "userId": user!.uid,
                });
                router.goToPage(PageName.home);
              },
              text: Globals.getText(gameServices.language, 64),
              btnType: BtnType.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
