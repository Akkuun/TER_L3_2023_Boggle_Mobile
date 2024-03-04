import 'package:bouggr/components/accelerometer.dart';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class StartGamePage extends StatelessWidget {
  const StartGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final gameServices = Provider.of<GameServices>(context, listen: false);
    BoggleAccelerometer accelerometer = BoggleAccelerometer();
    accelerometer.isShaking.addListener(() {
      if (accelerometer.isShaking.value) {
        //ici faire le retour hapitque
        Haptics.vibrate(HapticsType.success);
        print('Shake detected');
        if (gameServices.start(LangCode.FR, GameType.solo)) {
          router.goToPage(PageName.game);
        }
      }
    });

    return Center(
      child: Column(
        children: [
          accelerometer,
          BtnBoggle(
            onPressed: () {
              if (gameServices.start(LangCode.FR, GameType.solo)) {
                router.goToPage(PageName.game);
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
