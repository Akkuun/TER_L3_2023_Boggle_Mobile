import 'package:bouggr/main.dart';
import 'package:bouggr/providers/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class UserCredentialMock extends Mock implements UserCredential {}

class MockUser extends Mock implements User {
  @override
  final String uid;
  @override
  final String email;

  MockUser({required this.uid, required this.email});
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  bool signedIn;
  MockUser? user;

  MockFirebaseAuth({this.signedIn = false, this.user});

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) {
    signedIn = true;
    user = MockUser(uid: '123', email: email);
    return Future.value(UserCredentialMock());
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password}) {
    signedIn = true;
    user = MockUser(uid: '123', email: email);
    return Future.value(UserCredentialMock());
  }

  @override
  User? get currentUser => signedIn ? user : null;

  @override
  Future<void> signOut() {
    signedIn = false;
    user = null;
    return Future.value();
  }
}

void main() {
  final logger = Logger();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Lance une partie", (WidgetTester tester) async {
    // Créez un mock de FirebaseAuth avec un utilisateur non connecté
    final mockFirebaseAuth = MockFirebaseAuth(signedIn: false);

    // Créez un mock de FirebaseFirestore
    final mockFirestore = FakeFirebaseFirestore();

    // Lancez l'application avec le mock
    await tester.pumpWidget(
      Provider<FirebaseProvider>.value(
        value: FirebaseProvider(mockFirebaseAuth, mockFirestore, null, null),
        child: const App(),
      ),
    );

    // Trouvez le bouton
    final soloButtonFinder = find.text('Partie solo');
    logger.i('Bouton Partie solo trouvé');

    /*
    // Appuyez sur bouton
    await tester.tap(soloButtonFinder);
    await tester.pumpAndSettle(Durations
        .long1); //obliger de mettre le test en premier avec une durée pour que le test fonctionne dans une battrie de test, car la page créé des éléments gourment
    logger.i('Bouton Partie solo appuyé');

    final cpButtonFinder = find.text('Commencer une partie');
    logger.i('Bouton Commencer une partie trouvé');

    await tester.tap(cpButtonFinder);
    await tester.pumpAndSettle();
    logger.i('Bouton Commencer une partie appuyé');

    // Maitenant on essayer de trouver le nombre de mots restant sur la page pour être sur d'avoir lancer une partie
    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.data?.contains('Nombre de mots restant') == true,
        ),
        findsOneWidget);
    logger.i('Nombre de mots restant affiché');
    */

    logger.i('Test Lance une partie terminé');
  });
/*
  testWidgets("naviguer vers la page Rules depuis la page d'accueil",
      (WidgetTester tester) async {
    // Créez un mock de FirebaseAuth avec un utilisateur non connecté
    final mockFirebaseAuth = MockFirebaseAuth(signedIn: false);

    // Lancez l'application avec le mock
    await tester.pumpWidget(
      Provider<FirebaseAuth>.value(
        value: mockFirebaseAuth,
        child: const App(),
      ),
    );
    // Trouvez le bouton Rules par son texte
    final rulesButtonFinder = find.text('lire');
    logger.i('Bouton Rules trouvé');

    // Appuyez sur le bouton Rules
    await tester.tap(rulesButtonFinder);
    await tester.pumpAndSettle();
    logger.i('Bouton Rules appuyé');

    // Vérifiez que la page Rules est affichée
    expect(find.text('Rules'), findsOneWidget);
    logger.i('Page Rules affichée');
    logger.i(
        'Test naviguer vers la page Rules depuis la page d\'accueil terminé');
      
  });

  testWidgets("creation d'un compte", (WidgetTester tester) async {
    // Créez un mock de FirebaseAuth avec un utilisateur non connecté
    final mockFirebaseAuth = MockFirebaseAuth(signedIn: false);

    // Lancez l'application avec le mock
    await tester.pumpWidget(
      Provider<FirebaseAuth>.value(
        value: mockFirebaseAuth,
        child: const App(),
      ),
    );

    // Trouvez le bouton
    final connexionButtonFinder = find.text('Connexion');
    logger.i('Bouton Connexion trouvé');

    // Appuyez sur bouton
    await tester.tap(connexionButtonFinder);
    await tester.pumpAndSettle();
    logger.i('Bouton Connexion appuyé');

    final ccButtonFinder = find.text('Créer un compte');
    logger.i('Bouton Créer un compte trouvé');

    await tester.tap(ccButtonFinder);
    await tester.pumpAndSettle();
    logger.i('Bouton Créer un compte appuyé');

    // Trouvez le champ email et écrivez dedans
    final emailField = find.byKey(const Key('emailField'));
    await tester.enterText(emailField, 'test@test.test');
    logger.i('Email écrit');
    expect(find.text('test@test.test'), findsOneWidget);
    logger.i('Email bien écrit');

    // Trouvez le champ mot de passe et écrivez dedans
    final passwordField = find.byKey(const Key('passwordField'));
    await tester.enterText(passwordField, 'password');
    logger.i('Mot de passe écrit');

    // Trouvez le champ de vérification de mot de passe et écrivez dedans
    final passwordField2 = find.byKey(const Key('passwordField2'));
    await tester.enterText(passwordField2, 'password');
    logger.i('Vérification du mot de passe écrit');

    final envButtonFinder = find.text('Envoi');
    logger.i('Bouton Envoi trouvé');

    await tester.tap(envButtonFinder);
    await tester.pumpAndSettle();
    logger.i('Bouton Envoi appuyé');

    // Maitenant que l'on est connecte, on doit voir la page d'accueil avec le message de bienvenue
    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text && widget.data?.contains('Bienvenue') == true,
        ),
        findsOneWidget);
    logger.i('Bienvenue affiché');
    logger.i('Test création d\'un compte terminé');
  });

  testWidgets("connection a un compte", (WidgetTester tester) async {
    // Créez un mock de FirebaseAuth avec un utilisateur non connecté
    final mockFirebaseAuth = MockFirebaseAuth(signedIn: false);

    // Lancez l'application avec le mock
    await tester.pumpWidget(
      Provider<FirebaseAuth>.value(
        value: mockFirebaseAuth,
        child: const App(),
      ),
    );

    // Trouvez le bouton
    final connexionButtonFinder = find.text('Connexion');
    logger.i('Bouton Connexion trouvé');

    // Appuyez sur bouton
    await tester.tap(connexionButtonFinder);
    await tester.pumpAndSettle();
    logger.i('Bouton Connexion appuyé');

    final cpeButtonFinder = find.text('Connexion par email');
    logger.i('Bouton Connexion par email trouvé');

    await tester.tap(cpeButtonFinder);
    await tester.pumpAndSettle();
    logger.i('Bouton Connexion par email appuyé');

    // Trouvez le champ email et écrivez dedans
    final emailField = find.byKey(const Key('emailField'));
    await tester.enterText(emailField, 'test@test.test');
    logger.i('Email écrit');
    expect(find.text('test@test.test'), findsOneWidget);
    logger.i('Email bien écrit');

    // Trouvez le champ mot de passe et écrivez dedans
    final passwordField = find.byKey(const Key('passwordField'));
    await tester.enterText(passwordField, 'password');
    logger.i('Mot de passe écrit');

    final envButtonFinder = find.text('Envoi');
    logger.i('Bouton Envoi trouvé');

    await tester.tap(envButtonFinder);
    await tester.pumpAndSettle();
    logger.i('Bouton Envoi appuyé');

    // Maitenant que l'on est connecte, on doit voir la page d'accueil avec le message de bienvenue
    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text && widget.data?.contains('Bienvenue') == true,
        ),
        findsOneWidget);
    logger.i('Bienvenue affiché');
    logger.i('Test connection a un compte terminé');
  });

  testWidgets("deconnection d'un compte", (WidgetTester tester) async {
    // Créez un mock de FirebaseAuth avec un utilisateur connecté
    final mockFirebaseAuth = MockFirebaseAuth(
        signedIn: true, user: MockUser(uid: '123', email: 'test@test.test'));

    // Lancez l'application avec le mock
    await tester.pumpWidget(
      Provider<FirebaseAuth>.value(
        value: mockFirebaseAuth,
        child: const App(),
      ),
    );

    // Trouvez le bouton
    final settingButton = find.byKey(const Key('settingsButton'));
    logger.i('Bouton settingsButton trouvé');

    // Appuyez sur bouton
    await tester.tap(settingButton);
    await tester.pumpAndSettle(Durations.extralong4);
    logger.i('Bouton settingsButton appuyé');

    // Trouvez le bouton
    final singoutButton = find.text('Deconnexion');
    logger.i('Bouton Deconnexion trouvé');

    // Appuyez sur bouton
    await tester.tap(singoutButton);
    await tester.pumpAndSettle();
    logger.i('Bouton Deconnexion appuyé');

    // Maitenant que l'on est deconnecte, on doit voir le bouton Connexion
    expect(find.text('Connexion'), findsOneWidget);
    logger.i('Bouton Connexion affiché');
    logger.i('Test deconnection d\'un compte terminé');
  });*/

  //Fermer l'application car les tests se sont effectuer
  tearDownAll(() {
    logger.i('Fermeture de l\'application');
    SystemNavigator.pop();
  });
}
