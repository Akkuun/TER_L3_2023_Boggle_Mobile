import 'package:bouggr/components/bottom_buttons.dart';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/card.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/end_game_service.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final gameServices = Provider.of<GameServices>(context, listen: false);
    final firebaseAuth = Provider.of<FirebaseAuth>(context, listen: false);
    Widget welcomeWidget;
    var logger = Logger();

    User? user = firebaseAuth.currentUser;
    if (user != null) {
      welcomeWidget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "${user.email}",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontFamily: 'Jua',
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      welcomeWidget = BtnBoggle(
        onPressed: () {
          router.goToPage(PageName.login);
        },
        btnSize: BtnSize.large,
        text: Globals.getText(gameServices.language, 6),
      );
    }

    return BottomButtons(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: BoggleCard(
                  onPressed: () {
                    router.goToPage(PageName.rules);
                  },
                  title: Globals.getText(gameServices.language, 0),
                  action: Globals.getText(gameServices.language, 1),
                  child: Text(
                    '${Globals.getText(gameServices.language, 8)}\n${Globals.getText(gameServices.language, 9)}\n${Globals.getText(gameServices.language, 10)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Jua',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                  width:
                      0), // Ajoutez un espacement entre les cartes si nécessaire
              Expanded(
                child: BoggleCard(
                  title: Globals.getText(gameServices.language, 3),
                  action: Globals.getText(gameServices.language, 2),
                  onPressed: () {
                    //router.goToPage(PageName.rules);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 430,
            height: 113,
            child: AppTitle(),
          ),
          BtnBoggle(
            onPressed: () {
              Globals.selectDictionary(gameServices.language).load();
              router.goToPage(PageName.startGame);
              Provider.of<EndGameService>(context, listen: false)
                  .resetSelectedWord();
            },
            btnSize: BtnSize.large,
            text: Globals.getText(gameServices.language, 4),
          ),
          BtnBoggle(
            onPressed: () {
              logger.i('Create or join a multiplayer game');
              router.goToPage(PageName.multiplayerCreateJoin);
            },
            btnType: BtnType.secondary,
            btnSize: BtnSize.large,
            text: Globals.getText(gameServices.language, 5),
          ),
          welcomeWidget,
        ],
      ),
    );
  }
}
