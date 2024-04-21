import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:bouggr/utils/dice_set.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:mockito/mockito.dart';
import 'package:bouggr/utils/decode.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Créez une classe Mock pour simuler le comportement du NavigationServices
class MockGameServices extends Mock implements GameServices {
  MockGameServices() {
    when(language).thenReturn(LangCode.FR);
  }

  @override
  LangCode get language => super.noSuchMethod(
        Invocation.getter(#language),
        returnValue: LangCode.FR,
        returnValueForMissingStub: LangCode.FR,
      );
}

class MockNavigationServices extends Mock implements NavigationServices {
  @override
  PageName get index =>
      PageName.home; // Retourne une valeur par défaut pour index

  @override
  void goToPage(PageName page) {
    super.noSuchMethod(
      Invocation.method(#goToPage, [page]),
      returnValue: null,
      returnValueForMissingStub: null,
    );
  }
}

int countLetterInDiceSet(DiceSet diceSet, String letter) {
  int count = 0;
  for (List<String> dice in diceSet.dices) {
    for (String l in dice) {
      if (l == letter) {
        count++;
        break;
      }
    }
  }
  return count;
}

void main() {
  DiceSet listeDe = DiceSet(dices: [
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
  ]);

  /*group('HomePage unitaire', () {
    testWidgets('Test pour vérifier si on est sur la page HomePage',
        (WidgetTester tester) async {
      // Créez une instance de MockGameServices, MockNavigationServices et MockFirebaseAuth (Les Providers présent sur la page HomePage)
      final mockGameServices = MockGameServices();
      final mockNavigationServices = MockNavigationServices();
      final mockFirebaseAuth = MockFirebaseAuth();

      await tester.binding.setSurfaceSize(Size(1080, 1920));

      // Construisez notre application et déclenchez un "frame"
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<GameServices>.value(value: mockGameServices),
            ChangeNotifierProvider<NavigationServices>.value(
                value: mockNavigationServices),
            Provider<FirebaseAuth>.value(
                value:
                    mockFirebaseAuth), // Ajoutez FirebaseAuth à vos providers
          ],
          child: MaterialApp(
            home: HomePage(), // HomePage est le widget que nous testons
          ),
        ),
      );

      // Vérifiez que le widget HomePage est bien présent
      expect(find.byType(HomePage), findsOneWidget);
    });
  });*/

  group('BoggleGrille', () {
/*
    test('isWordValid retourn faux si le mots fait moins de 3 lettre', () {
      BoggleGrilleState boggleGrilleState = BoggleGrilleState();

      expect(boggleGrilleState.isWordValid('ab'), false);
    });
    test(
        'isWordValid retourne vrai si le mot fait au moins 3 lettres et est dans le dictionnaire',
        () {
      BoggleGrilleState boggleGrilleState = BoggleGrilleState();
      Dictionary dictionary = Dictionary(
          path: 'assets/dictionary/fr_dico.json',
          decoder: Decoded(lang: generateLangCode()));
      dictionary.load();
      boggleGrilleState.dictionary = dictionary;
      expect(boggleGrilleState.isWordValid('oignon'), true);
    });

    test(
        'isWordValid retourne faux si le mot fait au moins 3 lettres et n\'est pas dans le dictionnaire',
        () {});*/

    /*TestWidgetsFlutterBinding.ensureInitialized();

    test('trouver tout les mots d\'une grille', () async {
      List<String> grid = [
        'N',
        'N',
        'D',
        'U',
        'E',
        'E',
        'O',
        'R',
        'N',
        'A',
        'U',
        'Q',
        'I',
        'U',
        'R',
        'E'
      ];
      Dictionary dictionary = Dictionary(
          path: './fr_dico.json',
          decoder: Decoded(lang: generateLangCode()));
      await dictionary.load();
      while (dictionary.dictionary == null) {
        print('loading dictionary');
        sleep(Durations.extralong1);
        print('dictionary loaded');
      }
      List<Word>? words;

      await getAllWords2(grid, dictionary).then((value) => {words = value});
      while (words == null) {
        print('loading words');
        sleep(Durations.extralong1);
        print('words loaded');
      }

      print(words!.length);

      expect(words!.length, 10);
    });*/

    test('grille contient un bon nombre de E', () {
      List<String> letters = listeDe.roll();
      int count = 0;
      for (String letter in letters) {
        if (letter == 'E') {
          count++;
        }
      }

      print('Nombre de E: $count');
      //au maximum 12 fois la lettre E
      expect(count, lessThanOrEqualTo(countLetterInDiceSet(listeDe, 'E')));
    });

    test(
        'vérification que TOUTE les lettres sont en bon nombre dans une grille aléatoire',
        () {
      List<String> letters = listeDe.roll();
      print(letters);
      Map<String, int> count = <String,
          int>{}; //Map<lettre, nombre de fois que la lettre est présente>
      for (String letter in letters) {
        if (count.containsKey(letter)) {
          count[letter] = count[letter]! + 1;
        } else {
          count[letter] = 1;
        }
      }

      print(count);
      //chaque lettre doit être présente 1 fois
      for (String letter in count.keys) {
        print('Nombre de $letter: ${count[letter]}');
        expect(count[letter],
            lessThanOrEqualTo(countLetterInDiceSet(listeDe, letter)));
      }
    });
  });

  //Fermer l'application car les tests se sont effectuer
  /*tearDownAll(() {
    print('Fermeture de l\'application');
    SystemNavigator.pop();
  });*/
}
