import 'package:bouggr/components/btn.dart';
import 'package:bouggr/components/card.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bouggr/main.dart'; // Utilisez le bon chemin d'importation

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("naviguer vers la page Rules depuis la page d'accueil", (WidgetTester tester) async {
    // Lancez l'application
    await tester.pumpWidget(App()); // Utilisez App au lieu de Ap
    print('App lancée');
    // Trouvez le bouton Rules par son texte
    final rulesButtonFinder = find.text('read');
    print('Bouton Rules trouvé');

    // Appuyez sur le bouton Rules
    await tester.tap(rulesButtonFinder);
    await tester.pumpAndSettle();
    print('Bouton Rules appuyé');

    // Vérifiez que la page Rules est affichée
    expect(find.text('Rules'), findsOneWidget);
  });
}