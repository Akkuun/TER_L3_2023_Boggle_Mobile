import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/card.dart';
import 'package:bouggr/components/title.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/game_data.dart';
import 'package:bouggr/utils/game_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final gameServices = Provider.of<GameServices>(context, listen: false);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoggleCard(
                onPressed: () {
                  router.goToPage(PageName.rules);
                },
                title: "Rules",
                action: 'read',
                child: const Text(
                  'Find words\n&\nearn points',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Jua',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              BoggleCard(
                title: "SoonTm",
                action: 'play',
                onPressed: () {
                  router.goToPage(PageName.rules);
                },
              )
            ],
          ),
          const SizedBox(
            width: 430,
            height: 113,
            child: AppTitle(),
          ),
          BtnBoggle(
            onPressed: () {
              if (gameServices.start(LangCode.FR, GameType.solo)) {
                router.goToPage(PageName.game);
              }
            },
            btnSize: BtnSize.large,
            text: "SinglePlayer",
          ),
          BtnBoggle(
            onPressed: () {
              router.goToPage(PageName.login);
            },
            btnType: BtnType.secondary,
            btnSize: BtnSize.large,
            text: "Multiplayer",
          ),
          FutureBuilder<List<GameResult>>(
            future: GameDataStorage.loadGameResults(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final gameResults = snapshot.data!;
                return Column(
                  children: gameResults.map((result) {
                    return ListTile(
                      title: Text(result.playerName),
                      subtitle: Text(
                          'Score: ${result.score}'), //j'affiche les donnees dans cette page juste pour voir si ca marche(rafraichir la page a chaque fois)
                    );
                  }).toList(),
                );
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconBtnBoggle(
                icon: const Icon(Icons.home),
                onPressed: () {},
                btnType: BtnType.primary,
              ),
              IconBtnBoggle(
                icon: const Icon(Icons.extension),
                onPressed: () {},
                btnType: BtnType.secondary,
              ),
              IconBtnBoggle(
                icon: const Icon(Icons.insights),
                onPressed: () {
                  router.goToPage(PageName.stats);
                },
                btnType: BtnType.secondary,
              ),
            ],
          )
        ],
      ),
    );
  }
}
