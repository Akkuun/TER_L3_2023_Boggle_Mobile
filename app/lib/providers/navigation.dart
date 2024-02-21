import 'package:bouggr/pages/page_name.dart';
import 'package:flutter/material.dart';

/// c'est un listener qui permet de changer de page
/// il est utilisé dans main.dart
/// il est écouté dans page1.dart et page2.dart
class NavigationServices extends ChangeNotifier {
  var index = PageName.home;
  void goToPage(PageName here) {
    //fonction pour changer de page
    index = here;
    notifyListeners();
  }
}
