import 'package:bouggr/components/accelerometre.dart';
import 'package:bouggr/components/popup.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:provider/provider.dart';

class ReStartGamePage extends StatefulWidget {
  ReStartGamePage({super.key});

  final ValueNotifier<bool> _restart = ValueNotifier<bool>(false);

  ValueNotifier<bool> get restartNotifier => _restart;

  bool get getRestart => _restart.value;

  @override
  State<ReStartGamePage> createState() => _ReStartGamePageState();

  void setRestart(bool value) {
    _restart.value = value;
  }
}

class _ReStartGamePageState extends State<ReStartGamePage> {
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
        fileTaille: 10,
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
          _restartGame();
        }
      }
    }
  }

  void _restartGame() {
    print("restart pop");
    widget.setRestart(true);
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

    return accelerometre;
  }
}

class PopAccelo extends StatelessWidget {
  final ReStartGamePage
      restartGamePage; //on récupère la page de jeu car on veut la relancer

  const PopAccelo({super.key, required this.restartGamePage});

  @override
  Widget build(BuildContext context) {
    return PopUp<GameServices>(child: restartGamePage);
  }
}
