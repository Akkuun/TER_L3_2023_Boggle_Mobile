//globals

import 'package:bouggr/components/global/btn.dart';
import 'package:bouggr/components/game_page/only_multi/player_in_list.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/firebase.dart';
import 'package:bouggr/utils/player_leaderboard.dart';
import 'package:flutter/services.dart';

//services
import 'package:bouggr/providers/game.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

//flutter
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../components/global/title.dart';
import '../providers/navigation.dart';
import '../providers/realtimegame.dart';

class GameWaitPage extends StatelessWidget {
  static const TextStyle textStyle = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontFamily: 'Jua',
    fontWeight: FontWeight.w400,
  );
  static const textStyle2 = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontFamily: 'Jua',
    fontWeight: FontWeight.w400,
  );

  const GameWaitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    var rm = Provider.of<RealtimeGameProvider>(context);
    logger.i("[GAME WAIT] Game code : ${rm.gameCode}");
    var router = Provider.of<NavigationServices>(context, listen: false);
    var gameServices = Provider.of<GameServices>(context, listen: false);
    var data = rm.game;
    if (data.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    var players = data["players"];
    var gameStatus = data["status"];
    if (players != null && players!.isNotEmpty && gameStatus == 3) {
      for (var player in players!.entries) {
        gameServices.playerLeaderboard.addPlayer(
          PlayerStats(
              name: player.value['email'],
              score: player.value['score'],
              uid: player.key),
        );
      }
      gameServices.playerLeaderboard.remove(players.keys.toList());
    }

    logger.i("[GAME WAIT] Game status : $gameStatus && $data");

    if (gameStatus == 0) {
      logger.w("[GAME WAIT] Game is starting");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        router.goToPage(PageName.multiplayerGame);

        // remove the post frame callback
      });
    }

    User? user = Provider.of<FirebaseProvider>(context, listen: false).user;

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
          const CopyPasteCode(textStyle2: textStyle2),
          const Text(
            "Joueurs présents :",
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      ),
                    ],
                  ),
                  child: const PlayerWaitingList(),
                ),
              ),
            ),
          ),
          if (data != null &&
              data["players"] != null &&
              data["players"].length > 1 &&
              data["players"][
                      Provider.of<FirebaseProvider>(context, listen: false)
                          .user!
                          .uid] !=
                  null &&
              data["players"][
                  Provider.of<FirebaseProvider>(context, listen: false)
                      .user!
                      .uid]["leader"])
            BtnBoggle(
              // Start game
              onPressed: () async {
                final rep =
                    await Provider.of<FirebaseFunctions>(context, listen: false)
                        .httpsCallable('StartGame')
                        .call({
                  "gameId": rm.gameCode,
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
                Provider.of<RealtimeGameProvider>(context, listen: false)
                    .onDispose();

                Provider.of<FirebaseFunctions>(context, listen: false)
                    .httpsCallable('LeaveGame')
                    .call({
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

class CopyPasteCode extends StatelessWidget {
  const CopyPasteCode({
    super.key,
    required this.textStyle2,
  });

  final TextStyle textStyle2;

  @override
  Widget build(BuildContext context) {
    var rm = context.watch<RealtimeGameProvider>();
    return ElevatedButton(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: rm.gameCode));
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
            (states) => const Color.fromARGB(255, 89, 150, 194)),
      ),
      child: Text(
        "Code : ${rm.gameCode}",
        style: textStyle2,
      ),
    );
  }
}

class PlayerWaitingList extends StatelessWidget {
  const PlayerWaitingList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var rm = context.watch<RealtimeGameProvider>();
    var data = rm.game;
    if (data == null) {
      Logger().e("[PLAYER WAITING LIST] Data is null");
      return const SizedBox();
    }

    if (data["players"] == null) {
      Logger().e("[PLAYER WAITING LIST] Data is null");

      return const SizedBox();
    }

    //const SizedBox();
    return ListView.builder(
      itemCount: data["players"].length,
      itemBuilder: (context, index) {
        String key = data["players"].keys.elementAt(index);
        return PlayerInList(
          playerName: data["players"][key]["name"],
          color: index % 2 == 0
              ? const Color.fromARGB(255, 89, 150, 194)
              : const Color.fromARGB(255, 181, 224, 255),
        );
      },
    );
  }
}
