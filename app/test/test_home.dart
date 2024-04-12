import 'package:bouggr/components/card.dart';
import 'package:bouggr/pages/page_name.dart';
import 'package:bouggr/providers/game.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bouggr/pages/home.dart';
import 'package:bouggr/providers/navigation.dart';
import 'package:mockito/mockito.dart';

// Créez une classe Mock pour simuler le comportement du NavigationServices
class MockGameServices extends Mock implements GameServices {}

class MockNavigationServices extends Mock implements NavigationServices {
  @override
  PageName get index => PageName.home; // Retourne une valeur par défaut pour index

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
  group('HomePage unitaire', () {
    testWidgets('Test pour vérifier si on est sur la page HomePage',
        (WidgetTester tester) async {
      // Créez une instance de MockGameServices et MockNavigationServices
      final mockGameServices = MockGameServices();
      final mockNavigationServices = MockNavigationServices();

      await tester.binding.setSurfaceSize(
          Size(1080, 1920)); // Définir une taille d'écran plus grande

      // Construisez notre application et déclenchez un "frame"
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<GameServices>.value(value: mockGameServices),
            ChangeNotifierProvider<NavigationServices>.value(
                value: mockNavigationServices),
          ],
          child: MaterialApp(
            home: HomePage(), // HomePage est le widget que nous testons
          ),
        ),
      );

      // Vérifiez que le widget HomePage est bien présent
      expect(find.byType(HomePage), findsOneWidget);
    });
    /*testWidgets('Test de redirection vers la page Rules',
        (WidgetTester tester) async {
      // Créez une instance de MockGameServices et MockNavigationServices
      final mockGameServices = MockGameServices();
      final mockNavigationServices = MockNavigationServices();

      await tester.binding.setSurfaceSize(
          Size(1080, 1920)); // Définir une taille d'écran plus grande

      // Construisez notre application et déclenchez un "frame"
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<GameServices>.value(value: mockGameServices),
            ChangeNotifierProvider<NavigationServices>.value(
                value: mockNavigationServices),
          ],
          child: MaterialApp(
            home: HomePage(), // HomePage est le widget que nous testons
          ),
        ),
      );

      // Trouvez le bouton Rules par le titre
      final rulesButton = find.byWidgetPredicate(
        (Widget widget) => widget is BoggleCard && widget.title == 'Rules',
        description: 'BoggleCard with title Rules',
      );

      // Appuyez sur le bouton Rules
      await tester.tap(rulesButton);
      await tester.pumpAndSettle();
      verify(mockNavigationServices.goToPage(PageName.rules)).called(
          1); // Vérifiez que la méthode goToPage a été appelée exactement une fois
    });*/
  });
}
