import 'dart:convert';

import 'package:bouggr/providers/firebase.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatProvider extends ChangeNotifier {
  int _pageCount = 1;
  Map<int, dynamic> _cache = {};
  int _currentPage = 0;

  void goToPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  int get pageCount {
    return _pageCount;
  }

  int get currentPage {
    return _currentPage;
  }

  List<dynamic> getPageStats(
    FirebaseProvider fb,
  ) {
    if (fb.firebaseAuth.currentUser == null) {
      var res = (_cache[currentPage] ?? []).map((e) {
        return jsonDecode(e);
      }).toList();

      return res;
    }

    if (_cache.containsKey(currentPage)) {
      return _cache[currentPage];
    } else {
      _loadData(fb, currentPage);
      return [];
    }
  }

  clear() {
    _cache.clear();

    _pageCount = 1;
    _currentPage = 0;
    notifyListeners();
  }

  void loadStatsPageCount(FirebaseProvider fb) {
    if (fb.firebaseAuth.currentUser == null) {
      return;
    }

    fb.firebaseFirestore
        .collection('user_solo_games')
        .doc(fb.user?.uid)
        .collection('gameResults')
        .count()
        .get()
        .then((value) {
      _pageCount = ((value.count ?? 1) / 10).ceil();

      notifyListeners();
    });
  }

  void loadInitPage(FirebaseProvider fb) {
    if (fb.firebaseAuth.currentUser == null) {
      SharedPreferences.getInstance().then((prefs) {
        final List<String>? jsonList = prefs.getStringList(
            'gameResults'); // convertit les resultats en une liste dobjets GameResult

        _cache.addEntries([MapEntry(0, jsonList ?? [])]);
        notifyListeners();
      });

      return;
    }

    _cache = {};
    fb.firebaseFirestore
        .collection('user_solo_games')
        .doc(fb.user?.uid)
        .collection('gameResults')
        .orderBy('score', descending: true) // Tri par score décroissant
        .limit(10)
        .get()
        .then((value) {
      _cache.addEntries([MapEntry(0, value.docs)]);

      _currentPage = 0;

      notifyListeners();
    });
  }

  void nextPage(FirebaseProvider fb) {
    if (fb.firebaseAuth.currentUser == null) {
      return;
    }

    if (_currentPage < _pageCount - 1) {
      _currentPage++;

      if (!_cache.containsKey(currentPage)) {
        _loadData(fb, currentPage);
      } else {
        notifyListeners();
      }
    }
  }

  void previousPage(FirebaseProvider fb) {
    if (fb.firebaseAuth.currentUser == null) {
      return;
    }

    if (_currentPage > 0) {
      _currentPage--;
      if (!_cache.containsKey(currentPage)) {
        _loadData(fb, currentPage);
      } else {
        notifyListeners();
      }
    }

    return;
  }

  void setPage(int i, FirebaseProvider fb) {
    if (fb.firebaseAuth.currentUser == null) {
      return;
    }

    if (i == currentPage) {
      return;
    }

    _currentPage = i;

    if (!_cache.containsKey(currentPage)) {
      _loadData(fb, currentPage);
    } else {
      notifyListeners();
    }
  }

  void _loadData(FirebaseProvider fb, int page) {
    if (fb.firebaseAuth.currentUser == null) {
      SharedPreferences.getInstance().then((prefs) {
        final List<String>? jsonList = prefs.getStringList(
            'gameResults'); // convertit les resultats en une liste dobjets GameResult
        if (jsonList == null) {
          return [];
        }

        _cache.addEntries([MapEntry(page, jsonList)]);
        notifyListeners();
      });

      return;
    }

    if (page == 0) {
      fb.firebaseFirestore
          .collection('user_solo_games')
          .doc(fb.user?.uid)
          .collection('gameResults')
          .orderBy('score', descending: true) // Tri par score décroissant
          .limit(10)
          .get()
          .then((value) {
        _cache.addEntries([MapEntry(page, value.docs)]);

        notifyListeners();
      });
    } else {
      var q1 = fb.firebaseFirestore
          .collection('user_solo_games')
          .doc(fb.user?.uid)
          .collection('gameResults')
          .orderBy('score', descending: false)
          .limitToLast(page * 10)
          .snapshots()
          .first;

      q1.then((value) {
        fb.firebaseFirestore
            .collection('user_solo_games')
            .doc(fb.user?.uid)
            .collection('gameResults')
            .limit(10)
            .orderBy("score", descending: true)
            .startAfterDocument(value.docs.first)
            .get()
            .then((value) {
          //rezize the cache to the current page

          _cache.addEntries([MapEntry(page, value.docs)]);

          notifyListeners();
        });
      });
    }
  }
}
