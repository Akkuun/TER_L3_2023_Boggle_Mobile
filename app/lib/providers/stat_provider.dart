import 'package:bouggr/providers/firebase.dart';

import 'package:flutter/material.dart';

class StatProvider extends ChangeNotifier {
  int _pageCount = 0;
  Map<int, dynamic> _cache = {};
  int _currentPage = 0;

  dynamic lastPage;

  void setPageCount(int pageCount) {
    _pageCount = pageCount;
    notifyListeners();
  }

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
    if (_cache.containsKey(currentPage)) {
      return _cache[currentPage];
    } else {
      _loadData(fb);
      return [];
    }
  }

  clear() {
    _cache = {};
    _pageCount = 0;
    _currentPage = 0;
  }

  void loadStatsPageCount(FirebaseProvider fb) {
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
    _cache = {};
    fb.firebaseFirestore
        .collection('user_solo_games')
        .doc(fb.user?.uid)
        .collection('gameResults')
        .orderBy('score', descending: true) // Tri par score décroissant
        .limit(10)
        .get()
        .then((value) {
      _cache[0] = value.docs;

      _currentPage = 0;
      lastPage = value.docs[value.docs.length - 1];
      notifyListeners();
    });
  }

  void nextPage(FirebaseProvider fb) {
    if (_currentPage < _pageCount - 1) {
      _currentPage++;

      if (!_cache.containsKey(currentPage)) {
        _loadData(fb);
      } else {
        notifyListeners();
      }
    }
  }

  void previousPage(FirebaseProvider fb) {
    if (_currentPage > 0) {
      _currentPage--;
      if (!_cache.containsKey(currentPage)) {
        _loadData(fb);
      } else {
        notifyListeners();
      }
    }

    return;
  }

  void setPage(int i, FirebaseProvider fb) {
    if (i == _currentPage) {
      return;
    }

    _currentPage = i;

    if (!_cache.containsKey(currentPage)) {
      _loadData(fb);
    } else {
      notifyListeners();
    }
  }

  void _loadData(FirebaseProvider fb) {
    if (currentPage == 0) {
      fb.firebaseFirestore
          .collection('user_solo_games')
          .doc(fb.user?.uid)
          .collection('gameResults')
          .orderBy('score', descending: true) // Tri par score décroissant
          .limit(10)
          .get()
          .then((value) {
        _cache.addEntries([MapEntry(currentPage, value.docs)]);

        lastPage = value.docs[value.docs.length - 1];
        notifyListeners();
      });
    } else {
      lastPage = fb.firebaseFirestore
          .collection('user_solo_games')
          .doc(fb.user?.uid)
          .collection('gameResults')
          .orderBy('score', descending: false)
          .limit(pageCount * 10 - currentPage * 10)
          .get()
          .then((value) {
        _cache.addEntries([MapEntry(currentPage, value.docs)]);

        lastPage = value.docs[value.docs.length - 1];
        notifyListeners();
      });

      fb.firebaseFirestore
          .collection('user_solo_games')
          .doc(fb.user?.uid)
          .collection('gameResults')
          .limit(10)
          .orderBy("score", descending: true)
          .startAfterDocument(lastPage)
          .get()
          .then((value) {
        //rezize the cache to the current page

        _cache.addEntries([MapEntry(currentPage, value.docs)]);

        lastPage = value.docs[value.docs.length - 1];
        notifyListeners();
      });
    }
  }
}
