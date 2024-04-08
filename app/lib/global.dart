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
      0: 'Règles',
      1: 'lire',
      2: 'bientôt',
      3: 'Bientôt',
      4: 'Partie solo',
      5: 'Partie multijoueur',
      6: 'Connexion',
      7: 'Bienvenue',
      8: 'Trouve des mots',
      9: '&',
      10: 'gagne des points',
      11: 'Règles de base\n\nDans une limite de temps de 3 minutes, vous devez trouver un maximum de mots en formant des chaînes de lettres contiguës. Plus le mot est long, plus les points qu\'il vous rapporte sont importants.\nVous pouvez passer d\'une lettre à la suivante située directement à gauche, à droite, en haut, en bas, ou sur l\'une des quatre cases diagonales. Tout autre mouvement est interdit, tel l utilisation de la même lettre plus d\'une fois ou encore l utilisation de lettres non adjacente .\n\n',
      12: 'Déroulement de la partie\nLa partie se déroule en 3 étapes:\n1. Recherche des mots\n2. Décompte des points\n3. Fin de la partie\n\n ',
      13: 'Décompte des points\nLe décompte des points s\'effectue après que le temps de jeu de 3 minutes se soit écoulé. Chacun des mots que vous avez trouvés vous rapporte des points, selon le barème suivant: \n\n - Les mots composés de 3 ou 4 lettres valent 1 point. \n\n - Les mots composés de 5 lettres valent 2 points \n\n- Les mots composés de 6 lettres valent 3 points \n\n - Les mots composés de 7 lettres valent 5 points\n\n - Les mots composés de 8 lettres ou plus valent 11 points ou plus \n\n Pour les parties multijoueurs, un bonus de 5 points est attribué pour chaque mot trouvé par les deux joueurs, si les joueurs ont trouvé 1 mot en commun, ce dernier doit être retiré chez chacun des joueurs.',
      14: 'Retour',
      15 : 'Secouez votre téléphone pour \nlancer une partie',
      16 : 'ou',
      17 : 'Commencer une partie',
      18 : 'Rang',
      19 : 'Combo',
      20 : 'Score',
      21 : 'Nombre de mots restant ',
      22 : 'Longueur du plus long mot restant : ',
      23 : 'Longueur du plus long mot restant : 0',
      24 : 'Jeu mis en pause',
      25 : 'Nouvelle partie',
      26 : 'Accueil',
      27 : 'Détails',
      28 : 'Erreur',
      29 : 'Les informations d\'identification fournies sont incorrectes.',
      30 : 'Ok',
      31 : 'Connexion',
      32 : 'Créer un compte',
      33 : 'Connexion par email',
      34 : 'Email',
      35 : 'Mot de passe',
      36 : 'Le mot de passe doit contenir au moins 6 caractères!',
      37 : 'Mot de passe oublié',
      38 : 'Adresse mail non valide!',
      39 : 'Envoi',
      40 : 'Les mots de passe ne correspondent pas',
      41 : 'Déjà un compte ?',
      42 : 'O',
      43 : 'pt',
      44 : 'ions',
      45 : 'selectionnez une langue',
      46 : 'Langue sélectionnée : ',
      47 : 'Aucune langue sélectionnée',
      48 : 'Confirmer le mot de passe',
      49 : 'Changer de mot de passe',
      50 : 'Mot de passe changé avec succès',
      51 : 'Deconnexion',
      52 : 'Suppression du cache',
      53 : 'L\'utilisateur n\'est pas connecté ou les mots de passe sont vides',
      54 : 'Aucune donnée',
      55 : 'Aucun mot dans la grille ',
      56 : 'Fermer',
      57 : 'points',
      58 : 'Liste des plus longs',
      59 : 'Plus long mot trouvable : indiponible',
      60 : 'Plus long mot trouvé : ',
      61 : 'Score : ',
      62 : 'Score Max : indiponible',

    },
    LangCode.EN: {

    },
    LangCode.RM: {},
    LangCode.SP: {},

    LangCode.GLOBAL : {
      0: 'Règles',
      1: 'lire',
      2: 'bientôt',
      3: 'Bientôt',
      4: 'Partie solo',
      5: 'Partie multijoueur',
      6: 'Connexion',
      7: 'Bienvenue',
      8: 'Trouve des mots',
      9: '&',
      10: 'gagne des points',
      11: 'Règles de base\n\nDans une limite de temps de 3 minutes, vous devez trouver un maximum de mots en formant des chaînes de lettres contiguës. Plus le mot est long, plus les points qu\'il vous rapporte sont importants.\nVous pouvez passer d\'une lettre à la suivante située directement à gauche, à droite, en haut, en bas, ou sur l\'une des quatre cases diagonales. Tout autre mouvement est interdit, tel l utilisation de la même lettre plus d\'une fois ou encore l utilisation de lettres non adjacente .\n\n',
      12: 'Déroulement de la partie\nLa partie se déroule en 3 étapes:\n1. Recherche des mots\n2. Décompte des points\n3. Fin de la partie\n\n ',
      13: 'Décompte des points\nLe décompte des points s\'effectue après que le temps de jeu de 3 minutes se soit écoulé. Chacun des mots que vous avez trouvés vous rapporte des points, selon le barème suivant: \n\n - Les mots composés de 3 ou 4 lettres valent 1 point. \n\n - Les mots composés de 5 lettres valent 2 points \n\n- Les mots composés de 6 lettres valent 3 points \n\n - Les mots composés de 7 lettres valent 5 points\n\n - Les mots composés de 8 lettres ou plus valent 11 points ou plus \n\n Pour les parties multijoueurs, un bonus de 5 points est attribué pour chaque mot trouvé par les deux joueurs, si les joueurs ont trouvé 1 mot en commun, ce dernier doit être retiré chez chacun des joueurs.',
      14: 'Retour',
      15 : 'Secouez votre téléphone pour \nlancer une partie',
      16 : 'ou',
      17 : 'Commencer une partie',
      18 : 'Rang',
      19 : 'Combo',
      20 : 'Score',
      21 : 'Nombre de mots restant ',
      22 : 'Longueur du plus long mot restant : ',
      23 : 'Longueur du plus long mot restant : 0',
      24 : 'Jeu mis en pause',
      25 : 'Nouvelle partie',
      26 : 'Accueil',
      27 : 'Détails',
      28 : 'Erreur',
      29 : 'Les informations d\'identification fournies sont incorrectes.',
      30 : 'Ok',
      31 : 'Connexion',
      32 : 'Créer un compte',
      33 : 'Connexion par email',
      34 : 'Email',
      35 : 'Mot de passe',
      36 : 'Le mot de passe doit contenir au moins 6 caractères!',
      37 : 'Mot de passe oublié',
      38 : 'Adresse mail non valide!',
      39 : 'Envoi',
      40 : 'Les mots de passe ne correspondent pas',
      41 : 'Déjà un compte ?',
      42 : 'O',
      43 : 'pt',
      44 : 'ions',
      45 : 'selectionnez une langue',
      46 : 'Langue sélectionnée : ',
      47 : 'Aucune langue sélectionnée',
      48 : 'Confirmer le mot de passe',
      49 : 'Changer de mot de passe',
      50 : 'Mot de passe changé avec succès',
      51 : 'Deconnexion',
      52 : 'Suppression du cache',
      53 : 'L\'utilisateur n\'est pas connecté ou les mots de passe sont vides',
      54 : 'Aucune donnée',
      55 : 'Aucun mot dans la grille ',
      56 : 'Fermer',
      57 : 'points',
      58 : 'Liste des plus longs',
      59 : 'Plus long mot trouvable : indiponible',
      60 : 'Plus long mot trouvé : ',
      61 : 'Score : ',
      62 : 'Score Max : indiponible',
    }
  };

  //retourne le texte en fonction de la langue et de l'id
  static String getText(LangCode language, int id) {
    String text = texts[language]![id] ?? ''; // Récupérer le texte ou une chaîne vide si non trouvé

    return text.replaceAll('\\n',
        '\n'); // Remplacer les occurrences de '\n' par des sauts de ligne
  }
}
