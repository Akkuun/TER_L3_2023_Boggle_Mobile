import 'package:bouggr/components/accelerometer.dart';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartGamePage extends StatelessWidget {
  const StartGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final gameServices = Provider.of<GameServices>(context, listen: false);
    final acce = BoggleAccelerometer();

    return Center(
      child: Column(
        children: [
          acce,
          BtnBoggle(
            onPressed: () {
              if (acce.shakeDetected()) {
                if (gameServices.start(LangCode.FR, GameType.solo)) {
                  router.goToPage(PageName.game);
                }
              }
            },
            btnSize: BtnSize.large,
            text: "Commencer une partie",
          ),
          BtnBoggle(
            onPressed: () {
              router.goToPage(PageName.home);
            },
            btnType: BtnType.secondary,
            btnSize: BtnSize.small,
            text: "Go back",
          ),
        ],
      ),
    );
  }
}