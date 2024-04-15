import 'package:bouggr/components/card.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/pages/home.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:mockito/mockito.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bouggr/utils/dico.dart';
import 'package:bouggr/girlle_test.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/get_all_word.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Créez une classe Mock pour simuler le comportement du NavigationServices
class MockGameServices extends Mock implements GameServices {
  MockGameServices() {
    when(this.language).thenReturn(LangCode.FR);
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

void main() {
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
    //fiare test sur une grille qui se génère
    //faire test sur tout les mots trouver sur grille
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

    TestWidgetsFlutterBinding.ensureInitialized();

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
          path: 'assets/dictionary/fr_dico.json',
          decoder: Decoded(lang: generateLangCode()));
      dictionary.load();
      List<Word> words = await getAllWords2(grid, dictionary);

      print(words.length);

      expect(words.length, 10);
    });
  });

  //Fermer l'application car les tests se sont effectuer
  tearDownAll(() {
    print('Fermeture de l\'application');
    SystemNavigator.pop();
  });
}
