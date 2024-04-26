import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
//import 'package:bouggr/pages/multiplayer_gamealed.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:mockito/mockito.dart';

class MockNavigationServices extends Mock
    implements
        NavigationServices {} //créé un mock de la classe NavigationServices

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebase extends Mock implements FirebaseApp {}

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockFirebaseApp extends Mock implements FirebaseApp {}

class MockFirebaseService extends Mock implements FirebaseService {}

class MockUser extends Mock implements User {
  @override
  final String uid;

  MockUser({required this.uid});
}

class FirebaseService {
  Future<FirebaseApp> initializeApp() {
    return Firebase.initializeApp();
  }
}

void main() {
  /*final logger = Logger();
  group('MultiplayerGamePage', () {
    //group permet de regrouper les tests afin de les exécuter ensemble mais aussi de les organiser par catégories/thèmes
    testWidgets('Construction de la page sans erreur',
        (WidgetTester tester) async {
      logger.i('Initialisation de Firebase...');
      // Créer un mock de FirebaseService
      final mockFirebaseService = MockFirebaseService();

      // Utiliser le mock de Firebase lors de l'initialisation
      when(mockFirebaseService.initializeApp())
          .thenAnswer((_) => Future.value(MockFirebaseApp()));
      logger.i('Firebase initialisé.');

      // Initialiser le ChangeNotifier
      final navigationServices = NavigationServices();

      // Construire le widget de test
      await tester.pumpWidget(
        ChangeNotifierProvider<NavigationServices>.value(
          value: navigationServices,
          child: MaterialApp(
            home: MultiplayerGamePage(),
          ),
        ),
      );

      // Vérifier que MultiplayerGamePage est bien affiché
      expect(find.byType(MultiplayerGamePage), findsOneWidget);
    });
    
    testWidgets('La navigation vers le jeux lors que la creation de partie (button) est préssée s\'effectue', (WidgetTester tester) async {
      final mockNavigationServices = MockNavigationServices(); //crée un objet de la classe MockNavigationServices

      await tester.pumpWidget(
        ChangeNotifierProvider<NavigationServices>(
          create: (_) => mockNavigationServices, 
          child: const MaterialApp(
            home: MultiplayerGamePage(),
          ),
        ),
      );

      await tester.tap(find.text('Create a game')); //recherche le texte "Create a game" et appuis
      await tester.pumpAndSettle();

      verify(mockNavigationServices.goToPage(PageName.game)).called(1); //vérifie que la méthode goToPage de la classe NavigationServices est appelée une fois
    });

    testWidgets('Quand le bouton rejoindre partie est appuyer on dois retourner vers la home page', (WidgetTester tester) async {
      final mockNavigationServices = MockNavigationServices();

      await tester.pumpWidget(
        ChangeNotifierProvider<NavigationServices>(
          create: (_) => mockNavigationServices,
          child: const MaterialApp(
            home: MultiplayerGamePage(),
          ),
        ),
      );

      await tester.tap(find.text('Join a game'));
      await tester.pumpAndSettle();

      verify(mockNavigationServices.goToPage(PageName.home)).called(1);
    });
    
  });*/
}
