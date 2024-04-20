import 'dart:convert';

import 'package:flutter/services.dart';

// THIS IS NOT PRIORITARY TO IMPLEMENT - TO BE DONE LATER

enum LocalEntries {
  rulesTitles,
  read,
  soon,
  soloGame,
  multiplayerGame,
  connection,
  welcome,
  findWords,
  and,
  earnPoints,
  basicRules,
  gameProgress,
  pointsCount,
  back,
  shakePhone,
  or,
  startGame,
  rank,
  combo,
  score,
  remainingWords,
  longestRemainingWordLength,
  longestRemainingWordLengthDefault,
  gamePaused,
  newGame,
  home,
  details,
  error,
  loginError,
  ok,
  login,
  createAccount,
  emailLogin,
  email,
  password,
  passwordLengthError,
  forgottenPassword,
  invalidEmail,
  send,
  passwordsDontMatch,
  alreadyHaveAccount,
  options,
  selectionnezUneLangue,
  selectedLanguage,
  noLanguageSelected,
  confirmPassword,
  changePassword,
  passwordChanged,
  logout,
  clearCache,
  userNotConnected,
  noData,
  noWordInGrid,
  close,
  points,
  longestList,
  longestWordUnavailable,
  longestWordFound,
  maxScoreUnavailable,
}

const localFrMap = {
  [LocalEntries.rulesTitles]: "Règles",
  [LocalEntries.read]: "lire",
  [LocalEntries.soon]: "Bientôt",
  [LocalEntries.soloGame]: "Partie solo",
  [LocalEntries.multiplayerGame]: "Partie multijoueur",
  [LocalEntries.connection]: "Connexion",
  [LocalEntries.welcome]: "Bienvenue",
  [LocalEntries.findWords]: "Trouve des mots",
  [LocalEntries.and]: "&",
  [LocalEntries.earnPoints]: "gagne des points",
  [
    LocalEntries.basicRules
  ]: "Règles de base\n\nDans une limite de temps de 3 minutes, vous devez trouver un maximum de mots en formant des chaînes de lettres contiguës. Plus le mot est long, plus les points qu'il vous rapporte sont importants.\nVous pouvez passer d'une lettre à la suivante située directement à gauche, à droite, en haut, en bas, ou sur l'une des quatre cases diagonales. Tout autre mouvement est interdit, tel l utilisation de la même lettre plus d'une fois ou encore l utilisation de lettres non adjacente .\n\n",
  [
    LocalEntries.gameProgress
  ]: "Déroulement de la partie\nLa partie se déroule en 3 étapes:\n1. Recherche des mots\n2. Décompte des points\n3. Fin de la partie\n\n ",
  [
    LocalEntries.pointsCount
  ]: "Décompte des points\nLe décompte des points s'effectue après que le temps de jeu de 3 minutes se soit écoulé. Chacun des mots que vous avez trouvés vous rapporte des points, selon le barème suivant: \n\n - Les mots composés de 3 ou 4 lettres valent 1 point. \n\n - Les mots composés de 5 lettres valent 2 points \n\n- Les mots composés de 6 lettres valent 3 points \n\n - Les mots composés de 7 lettres valent 5 points\n\n - Les mots composés de 8 lettres ou plus valent 11 points ou plus\n\nPour les parties multijoueurs, un bonus de 5 points est attribué pour chaque mot trouvé par les deux joueurs, si les joueurs ont trouvé 1 mot en commun, ce dernier doit être retiré chez chacun des joueurs.",
  [LocalEntries.back]: "Retour",
  [LocalEntries.shakePhone]: "Secouez votre téléphone pour \nlancer une partie",
  [LocalEntries.or]: "ou",
  [LocalEntries.startGame]: "Commencer une partie",
  [LocalEntries.rank]: "Rang",
  [LocalEntries.combo]: "Combo",
  [LocalEntries.score]: "Score",
  [LocalEntries.remainingWords]: "Nombre de mots restant ",
  [LocalEntries.longestRemainingWordLength]:
      "Longueur du plus long mot restant : ",
  [LocalEntries.longestRemainingWordLengthDefault]:
      "Longueur du plus long mot restant : 0",
  [LocalEntries.gamePaused]: "Jeu mis en pause",
  [LocalEntries.newGame]: "Nouvelle partie",
  [LocalEntries.home]: "Accueil",
  [LocalEntries.details]: "Détails",
  [LocalEntries.error]: "Erreur",
  [LocalEntries.loginError]:
      "Les informations d'identification fournies sont incorrectes.",
  [LocalEntries.ok]: "Ok",
  [LocalEntries.login]: "Connexion",
  [LocalEntries.createAccount]: "Créer un compte",
  [LocalEntries.emailLogin]: "Connexion par email",
  [LocalEntries.email]: "Email",
  [LocalEntries.password]: "Mot de passe",
  [LocalEntries.passwordLengthError]:
      "Le mot de passe doit contenir au moins 6 caractères!",
  [LocalEntries.forgottenPassword]: "Mot de passe oublié",
  [LocalEntries.invalidEmail]: "Adresse mail non valide!",
  [LocalEntries.send]: "Envoi",
  [LocalEntries.passwordsDontMatch]: "Les mots de passe ne correspondent pas",
  [LocalEntries.alreadyHaveAccount]: "Déjà un compte ?",
  [LocalEntries.options]: "O\npt\nions",
  [LocalEntries.selectionnezUneLangue]: "selectionnez une langue",
  [LocalEntries.selectedLanguage]: "Langue sélectionnée : ",
  [LocalEntries.noLanguageSelected]: "Aucune langue sélectionnée",
  [LocalEntries.confirmPassword]: "Confirmer le mot de passe",
  [LocalEntries.changePassword]: "Changer de mot de passe",
  [LocalEntries.passwordChanged]: "Mot de passe changé avec succès",
  [LocalEntries.logout]: "Deconnexion",
  [LocalEntries.clearCache]: "Suppression du cache",
  [LocalEntries.userNotConnected]:
      "L'utilisateur n'est pas connecté ou les mots de passe sont vides",
  [LocalEntries.noData]: "Aucune donnée",
  [LocalEntries.noWordInGrid]: "Aucun mot dans la grille ",
  [LocalEntries.close]: "Fermer",
  [LocalEntries.points]: "points",
  [LocalEntries.longestList]: "Liste des plus longs",
  [LocalEntries.longestWordUnavailable]:
      "Plus long mot trouvable : indiponible",
  [LocalEntries.longestWordFound]: "Plus long mot trouvé : ",
  [LocalEntries.maxScoreUnavailable]: "Score Max : indiponible",
};

class LocalTranslate {
  String path;
  late Map<LocalEntries, String> _localMap;

  String get(LocalEntries entry) {
    return _localMap[entry] ?? '';
  }

  LocalTranslate({required this.path});

  load() {
    rootBundle.loadString(path).then((value) {
      _localMap = jsonDecode(value);
    });
  }

  unload() {
    _localMap = {};
  }
}
