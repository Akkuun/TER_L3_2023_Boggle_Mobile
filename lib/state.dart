import 'package:flutter/material.dart';

/// c'est un listener qui permet de changer de page
/// il est utilisé dans main.dart
/// il est écouté dans page1.dart et page2.dart
class MyAppState extends ChangeNotifier {
  var index=0;
  void goToPage(int here) { //fonction pour changer de page
    index=here;
    notifyListeners();
  }
}