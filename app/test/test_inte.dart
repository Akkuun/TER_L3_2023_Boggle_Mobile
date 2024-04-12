import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/card.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bouggr/main.dart'; // Utilisez le bon chemin d'importation
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /*testWidgets("naviguer vers la page Rules depuis la page d'accueil",
      (WidgetTester tester) async {
    // Lancez l'application
    await tester.pumpWidget(App()); // Utilisez App au lieu de Ap
    print('App lancée');
    // Trouvez le bouton Rules par son texte
    final rulesButtonFinder = find.text('lire');
    print('Bouton Rules trouvé');

    // Appuyez sur le bouton Rules
    await tester.tap(rulesButtonFinder);
    await tester.pumpAndSettle();
    print('Bouton Rules appuyé');

    // Vérifiez que la page Rules est affichée
    expect(find.text('Rules'), findsOneWidget);
  });*/

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
/*
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
    final emailField = find.text('Email'); // Remplacez 'email-field' par la clé de votre champ email
    await tester.enterText(emailField, 'test@test.test');
    print('Email écrit');

    // Trouvez le champ mot de passe et écrivez dedans
    final passwordField = find.text('Mot de passe'); // Remplacez 'password-field' par la clé de votre champ mot de passe
    await tester.enterText(passwordField, 'azertyuiop');
    print('Mot de passe écrit');

    final envButtonFinder = find.text('Envoi');
    print('Bouton Envoi trouvé');
    await tester.tap(envButtonFinder);
    await tester.pumpAndSettle();
    print('Bouton Envoi appuyé');

    // Vérifiez que la page Rules est affichée
    expect(find.text('Bienvenue'), findsOneWidget);*/
  });
}
