import 'package:bouggr/components/accelerometre.dart';
import 'package:bouggr/components/btn.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:haptic_feedback/haptic_feedback.dart';

class StartGamePage extends StatefulWidget {
  const StartGamePage({super.key});

  @override
  State<StartGamePage> createState() => _StartGamePageState();
}

class _StartGamePageState extends State<StartGamePage> {
  late BoggleAccelerometre accelerometre;
  // ignore: non_constant_identifier_names
  bool PageCharger = false;
  int nbSecousse = 0;
  int secousseDemander = 10;

  @override
  void initState() {
    // une fois le widget initialisé on crée un écouteur sur l'accéléromètre
    super.initState();

    accelerometre = BoggleAccelerometre(
        fileTaille: 6,
        seuilDetection: 20); //on donne des paramètres à l'accéléromètre
    accelerometre.estSecouer.addListener(_surDetectionSecousse);
  }

  @override
  void dispose() {
    // une vois le widget supprimer s'assure de la suppresion de l'écouteur
    accelerometre.estSecouer.removeListener(_surDetectionSecousse);
    super.dispose();
  }

  Future<void> _surDetectionSecousse() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (accelerometre.estSecouer.value && PageCharger) {
      Haptics.vibrate(HapticsType.rigid); // retour haptique
      nbSecousse++; // on incrémente le nombre de secousse
      accelerometre.estSecouer.value =
          false; // on remet à zéro la détection de secousse
      if (nbSecousse >= secousseDemander) {
        // si le nombre de secousse demander est atteint
        for (int i = 0; i < 3; i++) {
          //tentative de secousse personnalisée
          Haptics.vibrate(HapticsType.heavy);
          await Future.delayed(const Duration(
              milliseconds: 100)); // Attendez un peu entre chaque secousse
        }
        Haptics.vibrate(HapticsType.success); // retour haptique
        if (mounted) {
          // Vérifiez si le widget est monté avant de lancer le jeu car je sais pas pourquoi j'ai eu une erreur et c'est la solution d'après stackoverflow
          // Vérifiez si le widget est monté avant de lancer le jeu
          _startGame(); // on lance la partie
        }
      }
    }
  }

  void _startGame() {
    final router = Provider.of<NavigationServices>(context, listen: false);
    final gameServices = Provider.of<GameServices>(context, listen: false);

    if (gameServices.start(LangCode.FR)) {
      router.goToPage(PageName.game);
    }
  }

  @override
  Widget build(BuildContext context) {
    ///pour éviter le problème de mouvement du téléphone avant le chargement du widget
    //WidgetsBinding permet de faire des actions après le chargement du widget
    //instance permet de récupérer l'instance de l'application
    //addPostFrameCallback permet de faire une action après le chargement du widget
    //(_){...} est une fonction anonyme
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PageCharger = true; // une fois le widget chargé on met à jour la variable
    });

    final router = Provider.of<NavigationServices>(context, listen: false);
    final gameServices = Provider.of<GameServices>(context, listen: false);

    return Center(
      child: Column(
        children: [
          accelerometre,
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
              if (gameServices.start(LangCode.FR)) {
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
