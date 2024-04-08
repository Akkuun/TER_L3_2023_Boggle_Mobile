import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/dice_set.dart';
import 'package:bouggr/utils/dico.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// The `Globals` class is an inherited widget that provides access to global variables
/// the variable can be define for specific context or not
class Globals extends InheritedWidget {
  static String playerName = 'test'; // variable pour stocker le prénom

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String gameCode = '';
  static String currentMultiplayerGame = '';

  static final Map<LangCode, DiceSet> diceSets = {
    LangCode.FR: DiceSet(dices: [
      ["E", "T", "U", "K", "N", "O"],
      ["E", "V", "G", "T", "I", "N"],
      ["D", "E", "C", "A", "M", "P"],
      ["I", "E", "L", "R", "U", "W"],
      ["E", "H", "I", "F", "S", "E"],
      ["R", "E", "C", "A", "L", "S"],
      ["E", "N", "T", "D", "O", "S"],
      ["O", "F", "X", "R", "I", "A"],
      ["N", "A", "V", "E", "D", "Z"],
      ["E", "I", "O", "A", "T", "A"],
      ["G", "L", "E", "N", "Y", "U"],
      ["B", "M", "A", "Q", "J", "O"],
      ["T", "L", "I", "B", "R", "A"],
      ["S", "P", "U", "L", "T", "E"],
      ["A", "I", "M", "S", "O", "R"],
      ["E", "N", "H", "R", "I", "S"]
    ])
  };

  static final Map<LangCode, Dictionary> dictionaries = {
    LangCode.FR: Dictionary(
        path: 'assets/dictionary/fr_dico.json',
        decoder: Decoded(lang: generateLangCode())),
    LangCode.GLOBAL: Dictionary(
        path: 'assets/dictionary/global.json',
        decoder: Decoded(lang: generateLangCode())),
    LangCode.EN: Dictionary(
        path: 'assets/dictionary/en_dico.json',
        decoder: Decoded(lang: generateLangCode())),
    LangCode.SP: Dictionary(
        path: 'assets/dictionary/sp_dico.json',
        decoder: Decoded(lang: generateLangCode())),
    LangCode.RM: Dictionary(
        path: 'assets/dictionary/rm_dico.json',
        decoder: Decoded(lang: generateLangCode())),
  };

  const Globals({
    super.key,
    required super.child,
  });

  static Globals? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Globals>();

  static Dictionary selectDictionary(LangCode lang) {
    return dictionaries[lang]!;
  }

  static String getPlayerName() {
    return playerName;
  }

  static DiceSet selectDiceSet(LangCode lang) {
    return diceSets[lang] ?? diceSets[LangCode.FR]!;
  }

  static FirebaseFirestore db() {
    return _db;
  }

  @override
  bool updateShouldNotify(Globals oldWidget) => false;

// Pour Chaque langue, l'ensembles des textes utilisé

  static final Map<LangCode, Map<int, String>> texts = {
    LangCode.FR: {
      0:'Règles',
      1 : 'lire',
      2 : 'bientôt',
      3 : 'Bientôt',
      4 : 'Partie solo',
      5 : 'Partie multijoueur',
      6 :'Connexion',
      7 : 'Bienvenue',
      8 : 'Trouve des mots',
      9 : '&',
      10 : 'gagne des points',
      11 :  'Règles de base\n\nDans une limite de temps de 3 minutes, vous devez trouver un maximum de mots en formant des chaînes de lettres contiguës. Plus le mot est long, plus les points qu\'il vous rapporte sont importants.\nVous pouvez passer d\'une lettre à la suivante située directement à gauche, à droite, en haut, en bas, ou sur l\'une des quatre cases diagonales.\n',
      12 : 'Décompte des points\nLe décompte des points s\'effectue après que le temps de jeu de 3 minutes se soit écoulé. Chacun des mots que vous avez trouvés vous rapporte des points, selon le barème suivant:\n',
      13 :    '\nDécompte des points\nLe décompte des points s\'effectue après que le temps de jeu de 3 minutes se soit écoulé. Chacun des mots que vous avez trouvés vous rapporte des points, selon le barème suivant:',

    },
    LangCode.EN: {

    },
    LangCode.RM: {


    },
    LangCode.SP: {

    },
  };
  //retourne le texte en fonction de la langue et de l'id
  static String getText(LangCode language, int id) {
    String text = texts[language]![id] ?? ''; // Récupérer le texte ou une chaîne vide si non trouvé

    return text.replaceAll('\\n', '\n'); // Remplacer les occurrences de '\n' par des sauts de ligne

  }



}
