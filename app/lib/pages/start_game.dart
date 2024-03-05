import 'package:bouggr/components/accelerometer.dart';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:haptic_feedback/haptic_feedback.dart';

class StartGamePage extends StatefulWidget {
  const StartGamePage({super.key});

  @override
  StartGamePageState createState() => StartGamePageState();
}

class StartGamePageState extends State<StartGamePage> {
  late BoggleAccelerometer accelerometer;

  @override
  void initState() {
    // une fois le widget initialisé on crée un écouteur sur l'accéléromètre
    super.initState();

    accelerometer = BoggleAccelerometer();
    accelerometer.isShaking.addListener(_surDetectionSecousse);
  }

  @override
  void dispose() {
    // une vois le widget supprimer s'assure de la suppresion de l'écouteur
    accelerometer.isShaking.removeListener(_surDetectionSecousse);
    super.dispose();
  }

  void _surDetectionSecousse() {
    if (accelerometer.isShaking.value) {
      Haptics.vibrate(HapticsType.success); // retour haptique
      accelerometer.isShaking.value = false; // on remet à zéro la détection de secousse
      final gameServices = Provider.of<GameServices>(context, listen: false);
      if (gameServices.start(LangCode.FR, GameType.solo)) {
        final router = Provider.of<NavigationServices>(context, listen: false);
        router.goToPage(PageName.game);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]); // Force portrait mode

    final router = Provider.of<NavigationServices>(context, listen: false);
    final gameServices = Provider.of<GameServices>(context, listen: false);

    return Center(
      child: Column(
        children: [
          accelerometer,
          const Text(
            "Secouer votre téléphone pour lancer une partie",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontFamily: 'Jua',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height - 800),
          const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.waving_hand,
                  size: 100.0,
                ),
                Icon(
                  Icons.phone_android_rounded,
                  size: 100.0,
                )
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height - 750),
          const Text(
            "ou",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontFamily: 'Jua',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height - 780),
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
