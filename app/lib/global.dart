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

  static const Map<LangCode, Map<int, String>> texts = {
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
      13: 'Décompte des points\nLe décompte des points s\'effectue après que le temps de jeu de 3 minutes se soit écoulé. Chacun des mots que vous avez trouvés vous rapporte des points, selon le barème suivant: \n\n - Les mots composés de 3 ou 4 lettres valent 1 point. \n\n - Les mots composés de 5 lettres valent 2 points \n\n- Les mots composés de 6 lettres valent 3 points \n\n - Les mots composés de 7 lettres valent 5 points\n\n - Les mots composés de 8 lettres ou plus valent 11 points ou plus\n\nPour les parties multijoueurs, un bonus de 5 points est attribué pour chaque mot trouvé par les deux joueurs, si les joueurs ont trouvé 1 mot en commun, ce dernier doit être retiré chez chacun des joueurs.',
      14: 'Retour',
      15: 'Secouez votre téléphone pour \nlancer une partie',
      16: 'ou',
      17: 'Commencer une partie',
      18: 'Rang',
      19: 'Combo',
      20: 'Score',
      21: 'Nombre de mots restant ',
      22: 'Longueur du plus long mot restant : ',
      23: 'Longueur du plus long mot restant : 0',
      24: 'Jeu mis en pause',
      25: 'Nouvelle partie',
      26: 'Accueil',
      27: 'Détails',
      28: 'Erreur',
      29: 'Les informations d\'identification fournies sont incorrectes.',
      30: 'Ok',
      31: 'Connexion',
      32: 'Créer un compte',
      33: 'Connexion par email',
      34: 'Email',
      35: 'Mot de passe',
      36: 'Le mot de passe doit contenir au moins 6 caractères!',
      37: 'Mot de passe oublié',
      38: 'Adresse mail non valide!',
      39: 'Envoi',
      40: 'Les mots de passe ne correspondent pas',
      41: 'Déjà un compte ?',
      42: 'O',
      43: 'pt',
      44: 'ions',
      45: 'selectionnez une langue',
      46: 'Langue sélectionnée : ',
      47: 'Aucune langue sélectionnée',
      48: 'Confirmer le mot de passe',
      49: 'Changer de mot de passe',
      50: 'Mot de passe changé avec succès',
      51: 'Deconnexion',
      52: 'Suppression du cache',
      53: 'L\'utilisateur n\'est pas connecté ou les mots de passe sont vides',
      54: 'Aucune donnée',
      55: 'Aucun mot dans la grille ',
      56: 'Fermer',
      57: 'points',
      58: 'Liste des plus longs',
      59: 'Plus long mot trouvable : indiponible',
      60: 'Plus long mot trouvé : ',
      61: 'Score : ',
      62: 'Score Max : indiponible',
      63: 'Démarrer la partie',
      64: 'Quitter la partie',
    },
    LangCode.EN: {
      0: 'Rules',
      1: 'read',
      2: 'soon',
      3: 'Soon',
      4: 'SinglePlayer',
      5: 'MultiPlayer',
      6: 'Connection',
      7: ' Welcome',
      8: 'Find words',
      9: '&',
      10: 'earn points',
      11: 'Basic rules\n\nWithin a time limit of 3 minutes, you must find as many words as possible by forming chains of contiguous letters. The longer the word, the more points it earns you. You can move from one letter to the next located directly to the left, right, up, down, or on one of the four diagonal squares. Any other movement is prohibited, such as using the same letter more than once or using non-adjacent letters.\n\n',
      12: 'Gameplay\nThe game takes place in 3 stages:\n1. Word search\n2. Point count\n3. End of the game\n\n',
      13: 'Point count\nThe point count is done after the 3-minute game time has elapsed. Each of the words you have found earns you points, according to the following scale: \n\n - Words composed of 3 or 4 letters are worth 1 point. \n\n - Words composed of 5 letters are worth 2 points \n\n- Words composed of 6 letters are worth 3 points \n\n - Words composed of 7 letters are worth 5 points\n\n - Words composed of 8 letters or more are worth 11 points or more \n\n For multiplayer games, a bonus of 5 points is awarded for each word found by both players, if the players have found 1 word in common, the latter must be removed from each player.',
      14: 'Back',
      15: 'Shake your phone to \nstart a game',
      16: 'or',
      17: 'Start a game',
      18: 'Rank',
      19: 'Combo',
      20: 'Score',
      21: 'Number of words remaining ',
      22: 'Length of the longest remaining word : ',
      23: 'Length of the longest remaining word : 0',
      24: 'Game paused',
      25: 'New game',
      26: 'Home',
      27: 'Details',
      28: 'Error',
      29: 'The login information provided is incorrect.',
      30: 'Ok',
      31: 'Connection',
      32: 'Create an account',
      33: 'Connection by email',
      34: 'Email',
      35: 'Password',
      36: 'The password must contain at least 6 characters!',
      37: 'Forgotten password',
      38: 'Invalid email address!',
      39: 'Send',
      40: 'Passwords do not match',
      41: 'Already have an account?',
      42: 'Se',
      43: 'tt',
      44: 'ings',
      45: 'select a language',
      46: 'Selected language : ',
      47: 'No language selected',
      48: 'Confirm password',
      49: 'Change password',
      50: 'Password changed successfully',
      51: 'Logout',
      52: 'Clear cache',
      53: 'The user is not logged in or the passwords are empty',
      54: 'No data',
      55: 'No word in the grid ',
      56: 'Close',
      57: 'points',
      58: 'List of the longest',
      59: 'Longest word available: unavailable',
      60: 'Longest word found: ',
      61: 'Score: ',
      62: 'Max score: unavailable',
      63: 'Start the game',
      64: 'Leave the game',
    },
    //roumain
    LangCode.RM: {
      0: 'Reguli',
      1: 'citit',
      2: 'soon',
      3: 'În curând',
      4: 'Un jucător',
      5: 'Multiplayer',
      6: 'Conexiune',
      7: 'Bine ai venit',
      8: 'Caută cuvinte',
      9: '&',
      10: 'câstigă puncte',
      11: 'Reguli de bază\n\nÎntr-un interval de timp de 3 minute, trebuie să găsești cât mai multe cuvinte posibil formând lanțuri de litere contigue. Cu cât este mai lung cuvântul, cu atât mai multe puncte vei câștiga. Poți trece de la o literă la următoarea situată direct la stânga, dreapta, sus, jos sau pe una dintre cele patru pătrate diagonale. Orice altă mișcare este interzisă, cum ar fi folosirea aceleiași litere de mai multe ori sau folosirea literelor neadiacente.\n\n',
      12: 'Joc\nJocul se desfășoară în 3 etape:\n1. Căutarea cuvintelor\n2. Numărarea punctelor\n3. Sfârșitul jocului\n\n',
      13: 'Numărarea punctelor\nNumărarea punctelor se face după ce au trecut cele 3 minute de joc. Fiecare dintre cuvintele pe care le-ai găsit îți aduce puncte, conform următorului baraj: \n\n - Cuvintele compuse din 3 sau 4 litere valorează 1 punct. \n\n - Cuvintele compuse din 5 litere valorează 2 puncte \n\n- Cuvintele compuse din 6 litere valorează 3 puncte \n\n - Cuvintele compuse din 7 litere valorează 5 puncte\n\n - Cuvintele compuse din 8 litere sau mai mult valorează 11 puncte sau mai mult \n\n Pentru jocurile multiplayer, se acordă un bonus de 5 puncte pentru fiecare cuvânt găsit de ambii jucători, dacă jucătorii au găsit 1 cuvânt în comun, acesta din urmă trebuie eliminat de la fiecare jucător.',
      14: 'Înapoi',
      15: 'Agitați telefonul pentru \na începe un joc',
      16: 'sau',
      17: 'Începe un joc',
      18: 'Rang',
      19: 'Combo',
      20: 'Puncte',
      21: 'Numărul de cuvinte rămase ',
      22: 'Lungimea celui mai lung cuvânt rămas : ',
      23: 'Lungimea celui mai lung cuvânt rămas : 0',
      24: 'Joc în pauză',
      25: 'Joc nou',
      26: 'Acasă',
      27: 'Detalii',
      28: 'Eroare',
      29: 'Informațiile de conectare furnizate sunt incorecte.',
      30: 'Ok',
      31: 'Conexiune',
      32: 'Creează un cont',
      33: 'Conectare prin email',
      34: 'Email',
      35: 'Parolă',
      36: 'Parola trebuie să conțină cel puțin 6 caractere!',
      37: 'Parolă uitată',
      38: 'Adresă de email nevalidă!',
      39: 'Trimite',
      40: 'Parolele nu se potrivesc',
      41: 'Ai deja un cont?',
      42: 'Sau',
      43: 'pt',
      44: 'ion',
      45: 'selectează o limbă',
      46: 'Limbă selectată : ',
      47: 'Nicio limbă selectată',
      48: 'Confirmă parola',
      49: 'Schimbă parola',
      50: 'Parola schimbată cu succes',
      51: 'Deconectare',
      52: 'Șterge cache-ul',
      53: 'Utilizatorul nu este conectat sau parolele sunt goale',
      54: 'Fără date',
      55: 'Niciun cuvânt în grilă ',
      56: 'Închide',
      57: 'puncte',
      58: 'Lista celor mai lungi',
      59: 'Cel mai lung cuvânt disponibil: indisponibil',
      60: 'Cel mai lung cuvânt găsit: ',
      61: 'Punctaj: ',
      62: 'Punctaj maxim: indisponibil',
      63: 'Începe jocul',
      64: 'Părăsește jocul',
    },
    LangCode.SP: {
      0: 'Reglas',
      1: 'leer',
      2: 'pronto',
      3: 'Pronto',
      4: 'Un jugador',
      5: 'Multijugador',
      6: 'Conexión',
      7: 'Bienvenido',
      8: 'buscar palabras',
      9: '&',
      10: 'gana puntos',
      11: 'Reglas básicas\n\nDentro de un límite de tiempo de 3 minutos, debes encontrar tantas palabras como sea posible formando cadenas de letras contiguas. Cuanto más larga sea la palabra, más puntos te ganará. Puedes moverte de una letra a la siguiente ubicada directamente a la izquierda, derecha, arriba, abajo o en una de las cuatro casillas diagonales. Se prohíbe cualquier otro movimiento, como usar la misma letra más de una vez o usar letras no adyacentes.\n\n',
      12: 'Jugabilidad\nEl juego se desarrolla en 3 etapas:\n1. Búsqueda de palabras\n2. Conteo de puntos\n3. Fin del juego\n\n',
      13: 'Conteo de puntos\nEl conteo de puntos se realiza después de que haya transcurrido el tiempo de juego de 3 minutos. Cada una de las palabras que has encontrado te otorga puntos, según la siguiente escala: \n\n-Las palabras compuestas por 3 o 4 letras valen 1 punto. \n\n-Las palabras compuestas por 5 letras valen 2 puntos \n\n-Las palabras compuestas por 6 letras valen 3 puntos \n\n-Las palabras compuestas por 7 letras valen 5 puntos\n\n-Las palabras compuestas por 8 letras o más valen 11 puntos o más \n\nPara los juegos multijugador, se otorga un bono de 5 puntos por cada palabra encontrada por ambos jugadores, si los jugadores han encontrado 1 palabra en común, esta última debe eliminarse de cada jugador.',
      14: 'Volver',
      15: 'Agita tu teléfono para \ncomenzar un juego',
      16: 'o',
      17: 'Comenzar un juego',
      18: 'Rango',
      19: 'Combo',
      20: 'Puntos',
      21: 'Número de palabras restantes',
      22: 'Longitud de la palabra restante más larga:',
      23: 'Longitud de la palabra restante más larga : 0',
      24: 'Juego en pausa',
      25: 'Nuevo juego',
      26: 'Inicio',
      27: 'Detalles',
      28: 'Error',
      29: 'La información de inicio de sesión proporcionada es incorrecta.',
      30: 'Ok',
      31: 'Conexión',
      32: 'Crear una cuenta',
      33: 'Conexión por email',
      34: 'Correo electrónico',
      35: 'Contraseña',
      36: '¡La contraseña debe contener al menos 6 caracteres!',
      37: 'Contraseña olvidada',
      38: '¡Dirección de correo electrónico no válida!',
      39: 'Enviar',
      40: 'Las contraseñas no coinciden',
      41: '¿Ya tienes una cuenta?',
      42: 'O',
      43: 'pc',
      44: 'ión',
      45: 'selecciona un idioma',
      46: 'Idioma seleccionado : ',
      47: 'Ningún idioma seleccionado',
      48: 'Confirmar contraseña',
      49: 'Cambiar contraseña',
      50: 'Contraseña cambiada con éxito',
      51: 'Cerrar sesión',
      52: 'Borrar caché',
      53: 'El usuario no está conectado o las contraseñas están vacías',
      54: 'Sin datos',
      55: 'Ninguna palabra en la cuadrícula ',
      56: 'Cerrar',
      57: 'puntos',
      58: 'Lista de los más largos',
      59: 'Palabra más larga disponible: no disponible',
      60: 'Palabra más larga encontrada: ',
      61: 'Puntos: ',
      62: 'Puntuación máxima: no disponible',
      63: 'Comenzar el juego',
      64: 'Dejar el juego',
    },

    LangCode.GLOBAL: {
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
      13: 'Décompte des points\nLe décompte des points s\'effectue après que le temps de jeu de 3 minutes se soit écoulé. Chacun des mots que vous avez trouvés vous rapporte des points, selon le barème suivant: \n\n - Les mots composés de 3 ou 4 lettres valent 1 point. \n\n - Les mots composés de 5 lettres valent 2 points \n\n- Les mots composés de 6 lettres valent 3 points \n\n - Les mots composés de 7 lettres valent 5 points\n\n - Les mots composés de 8 lettres ou plus valent 11 points ou plus\n\nPour les parties multijoueurs, un bonus de 5 points est attribué pour chaque mot trouvé par les deux joueurs, si les joueurs ont trouvé 1 mot en commun, ce dernier doit être retiré chez chacun des joueurs.',
      14: 'Retour',
      15: 'Secouez votre téléphone pour \nlancer une partie',
      16: 'ou',
      17: 'Commencer une partie',
      18: 'Rang',
      19: 'Combo',
      20: 'Score',
      21: 'Nombre de mots restant ',
      22: 'Longueur du plus long mot restant : ',
      23: 'Longueur du plus long mot restant : 0',
      24: 'Jeu mis en pause',
      25: 'Nouvelle partie',
      26: 'Accueil',
      27: 'Détails',
      28: 'Erreur',
      29: 'Les informations d\'identification fournies sont incorrectes.',
      30: 'Ok',
      31: 'Connexion',
      32: 'Créer un compte',
      33: 'Connexion par email',
      34: 'Email',
      35: 'Mot de passe',
      36: 'Le mot de passe doit contenir au moins 6 caractères!',
      37: 'Mot de passe oublié',
      38: 'Adresse mail non valide!',
      39: 'Envoi',
      40: 'Les mots de passe ne correspondent pas',
      41: 'Déjà un compte ?',
      42: 'O',
      43: 'pt',
      44: 'ions',
      45: 'selectionnez une langue',
      46: 'Langue sélectionnée : ',
      47: 'Aucune langue sélectionnée',
      48: 'Confirmer le mot de passe',
      49: 'Changer de mot de passe',
      50: 'Mot de passe changé avec succès',
      51: 'Deconnexion',
      52: 'Suppression du cache',
      53: 'L\'utilisateur n\'est pas connecté ou les mots de passe sont vides',
      54: 'Aucune donnée',
      55: 'Aucun mot dans la grille ',
      56: 'Fermer',
      57: 'points',
      58: 'Liste des plus longs',
      59: 'Plus long mot trouvable : indiponible',
      60: 'Plus long mot trouvé : ',
      61: 'Score : ',
      62: 'Score Max : indiponible',
      63: 'Démarrer la partie',
      64: 'Quitter la partie',
    },
  };

  //retourne le texte en fonction de la langue et de l'id
  static String getText(LangCode language, int id) {
    String text = texts[language]![id] ??
        ''; // Récupérer le texte ou une chaîne vide si non trouvé

    return text.replaceAll('\\n',
        '\n'); // Remplacer les occurrences de '\n' par des sauts de ligne
  }

  static void resetMultiplayerData() {
    gameCode = '';
    currentMultiplayerGame = '';
  }
}
