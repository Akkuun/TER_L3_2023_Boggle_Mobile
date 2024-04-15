import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/card.dart';
import 'package:bouggr/global.dart';
import 'package:bouggr/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bouggr/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

class UserCredentialMock extends Mock implements UserCredential {}

class MockUser extends Mock implements User {
  final String uid;
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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Lance une partie", (WidgetTester tester) async {
    // Créez un mock de FirebaseAuth avec un utilisateur non connecté
    final mockFirebaseAuth = MockFirebaseAuth(signedIn: false);

    // Lancez l'application avec le mock
    await tester.pumpWidget(
      Provider<FirebaseAuth>.value(
        value: mockFirebaseAuth,
        child: App(),
      ),
    );

    // Trouvez le bouton
    final soloButtonFinder = find.text('Partie solo');
    print('Bouton Partie solo trouvé');

    // Appuyez sur bouton
    await tester.tap(soloButtonFinder);
    await tester
        .pumpAndSettle(Durations.long1); //obliger de mettre le test en premier avec une durée pour que le test fonctionne dans une battrie de test, car la page créé des éléments gourment
    print('Bouton Partie solo appuyé');

    final cpButtonFinder = find.text('Commencer une partie');
    print('Bouton Commencer une partie trouvé');

    await tester.tap(cpButtonFinder);
    await tester.pumpAndSettle();
    print('Bouton Commencer une partie appuyé');

    // Maitenant on essayer de trouver le nombre de mots restant sur la page pour être sur d'avoir lancer une partie
    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              widget.data?.contains('Nombre de mots restant') == true,
        ),
        findsOneWidget);
    print('Nombre de mots restant affiché');
    print('Test Lance une partie terminé');
  });

  testWidgets("naviguer vers la page Rules depuis la page d'accueil",
      (WidgetTester tester) async {
    // Créez un mock de FirebaseAuth avec un utilisateur non connecté
    final mockFirebaseAuth = MockFirebaseAuth(signedIn: false);

    // Lancez l'application avec le mock
    await tester.pumpWidget(
      Provider<FirebaseAuth>.value(
        value: mockFirebaseAuth,
        child: App(),
      ),
    );
    // Trouvez le bouton Rules par son texte
    final rulesButtonFinder = find.text('lire');
    print('Bouton Rules trouvé');

    // Appuyez sur le bouton Rules
    await tester.tap(rulesButtonFinder);
    await tester.pumpAndSettle();
    print('Bouton Rules appuyé');

    // Vérifiez que la page Rules est affichée
    expect(find.text('Rules'), findsOneWidget);
    print('Page Rules affichée');
    print('Test naviguer vers la page Rules depuis la page d\'accueil terminé');
  });

  testWidgets("creation d'un compte", (WidgetTester tester) async {
    // Créez un mock de FirebaseAuth avec un utilisateur non connecté
    final mockFirebaseAuth = MockFirebaseAuth(signedIn: false);

    // Lancez l'application avec le mock
    await tester.pumpWidget(
      Provider<FirebaseAuth>.value(
        value: mockFirebaseAuth,
        child: App(),
      ),
    );

    // Trouvez le bouton
    final connexionButtonFinder = find.text('Connexion');
    print('Bouton Connexion trouvé');

    // Appuyez sur bouton
    await tester.tap(connexionButtonFinder);
    await tester.pumpAndSettle();
    print('Bouton Connexion appuyé');

    final ccButtonFinder = find.text('Créer un compte');
    print('Bouton Créer un compte trouvé');

    await tester.tap(ccButtonFinder);
    await tester.pumpAndSettle();
    print('Bouton Créer un compte appuyé');

    // Trouvez le champ email et écrivez dedans
    final emailField = find.byKey(const Key('emailField'));
    await tester.enterText(emailField, 'test@test.test');
    print('Email écrit');
    expect(find.text('test@test.test'), findsOneWidget);
    print('Email bien écrit');

    // Trouvez le champ mot de passe et écrivez dedans
    final passwordField = find.byKey(const Key('passwordField'));
    await tester.enterText(passwordField, 'password');
    print('Mot de passe écrit');

    // Trouvez le champ de vérification de mot de passe et écrivez dedans
    final passwordField2 = find.byKey(const Key('passwordField2'));
    await tester.enterText(passwordField2, 'password');
    print('Vérification du mot de passe écrit');

    final envButtonFinder = find.text('Envoi');
    print('Bouton Envoi trouvé');

    await tester.tap(envButtonFinder);
    await tester.pumpAndSettle();
    print('Bouton Envoi appuyé');

    // Maitenant que l'on est connecte, on doit voir la page d'accueil avec le message de bienvenue
    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text && widget.data?.contains('Bienvenue') == true,
        ),
        findsOneWidget);
    print('Bienvenue affiché');
    print('Test création d\'un compte terminé');
  });

  testWidgets("connection a un compte", (WidgetTester tester) async {
    // Créez un mock de FirebaseAuth avec un utilisateur non connecté
    final mockFirebaseAuth = MockFirebaseAuth(signedIn: false);

    // Lancez l'application avec le mock
    await tester.pumpWidget(
      Provider<FirebaseAuth>.value(
        value: mockFirebaseAuth,
        child: App(),
      ),
    );

    // Trouvez le bouton
    final connexionButtonFinder = find.text('Connexion');
    print('Bouton Connexion trouvé');

    // Appuyez sur bouton
    await tester.tap(connexionButtonFinder);
    await tester.pumpAndSettle();
    print('Bouton Connexion appuyé');

    final cpeButtonFinder = find.text('Connexion par email');
    print('Bouton Connexion par email trouvé');

    await tester.tap(cpeButtonFinder);
    await tester.pumpAndSettle();
    print('Bouton Connexion par email appuyé');

    // Trouvez le champ email et écrivez dedans
    final emailField = find.byKey(const Key('emailField'));
    await tester.enterText(emailField, 'test@test.test');
    print('Email écrit');
    expect(find.text('test@test.test'), findsOneWidget);
    print('Email bien écrit');

    // Trouvez le champ mot de passe et écrivez dedans
    final passwordField = find.byKey(const Key('passwordField'));
    await tester.enterText(passwordField, 'password');
    print('Mot de passe écrit');

    final envButtonFinder = find.text('Envoi');
    print('Bouton Envoi trouvé');

    await tester.tap(envButtonFinder);
    await tester.pumpAndSettle();
    print('Bouton Envoi appuyé');

    // Maitenant que l'on est connecte, on doit voir la page d'accueil avec le message de bienvenue
    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text && widget.data?.contains('Bienvenue') == true,
        ),
        findsOneWidget);
    print('Bienvenue affiché');
    print('Test connection a un compte terminé');
  });

  testWidgets("deconnection d'un compte", (WidgetTester tester) async {
    // Créez un mock de FirebaseAuth avec un utilisateur connecté
    final mockFirebaseAuth = MockFirebaseAuth(
        signedIn: true, user: MockUser(uid: '123', email: 'test@test.test'));
    
    // Lancez l'application avec le mock
    await tester.pumpWidget(
      Provider<FirebaseAuth>.value(
        value: mockFirebaseAuth,
        child: App(),
      ),
    );

    // Trouvez le bouton
    final settingButton = find.byKey(const Key('settingsButton'));
    print('Bouton settingsButton trouvé');

    // Appuyez sur bouton
    await tester.tap(settingButton);
    await tester.pumpAndSettle(Durations.extralong4);
    print('Bouton settingsButton appuyé');

    // Trouvez le bouton
    final singoutButton =  find.text('Deconnexion');
    print('Bouton Deconnexion trouvé');

    // Appuyez sur bouton
    await tester.tap(singoutButton);
    await tester.pumpAndSettle();
    print('Bouton Deconnexion appuyé');

    // Maitenant que l'on est deconnecte, on doit voir le bouton Connexion
    expect(find.text('Connexion'), findsOneWidget);
    print('Bouton Connexion affiché');
    print('Test deconnection d\'un compte terminé');
  });

  //Fermer l'application car les tests se sont effectuer
  tearDownAll(() {
    print('Fermeture de l\'application');
    SystemNavigator.pop();
  });
}
