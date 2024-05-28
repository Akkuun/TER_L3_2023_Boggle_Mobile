import 'package:bouggr/providers/firebase.dart';

import 'package:flutter/material.dart';

class StatProvider extends ChangeNotifier {
  int _pageCount = 0;
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
      return [];
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

    _pageCount = 0;
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
      _pageCount = ((value.count ?? 0) / 10).ceil();

      notifyListeners();
    });
  }

  void loadInitPage(FirebaseProvider fb) {
    if (fb.firebaseAuth.currentUser == null) {
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
