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
    if (!fb.isConnected) {
      List<dynamic> res = _cache[currentPage] ?? [];

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
    if (!fb.isConnected) {
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
    if (!fb.isConnected) {
      SharedPreferences.getInstance().then((prefs) {
        final List<String> jsonList = prefs.getStringList('local_stat_sync') ??
            []; // convertit les resultats en une liste dobjets GameResult

        jsonList.addAll(prefs.getStringList('gameResults') ??
            []); // convertit les resultats en une liste dobjets GameResult

        var decoded = jsonList.map((e) => jsonDecode(e)).toList();

        decoded.sort((a, b) => b['score'] - (a['score']));

        _pageCount = (decoded.length / 10).ceil();

        for (var i = 0; i < _pageCount; i++) {
          _cache.addEntries([
            MapEntry(
                i,
                decoded.sublist(
                    i * 10,
                    (i + 1) * 10 > decoded.length
                        ? decoded.length
                        : (i + 1) * 10))
          ]);
        }

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
    if (!fb.isConnected) {
      SharedPreferences.getInstance().then((prefs) {
        final List<String> jsonList = prefs.getStringList('local_stat_sync') ??
            []; // convertit les resultats en une liste dobjets GameResult

        jsonList.addAll(prefs.getStringList('gameResults') ??
            []); // convertit les resultats en une liste dobjets GameResult

        var decoded = jsonList.map((e) => jsonDecode(e)).toList();

        decoded.sort((a, b) => b['score'] - (a['score']));

        _cache.addEntries(
            [MapEntry(page, decoded.sublist(page * 10, (page + 1) * 10))]);
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
