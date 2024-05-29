import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseDatabase? _realtimeDatabase;
  final FirebaseFunctions? _firebaseFunctions;
  static StreamSubscription? _listener;

  bool _isConnected = true;

  FirebaseProvider(
    this._firebaseAuth,
    this._firebaseFirestore,
    this._realtimeDatabase,
    this._firebaseFunctions,
  ) {
    if (_listener != null) {
      _listener!.cancel();
    }

    _firebaseAuth.authStateChanges().listen((User? user) {
      if ((user != null) != _isConnected) {
        _isConnected = user != null;

        notifyListeners();
        if (_isConnected) {
          _syncStats();
        }
      }
    });
  }

  bool get isConnected => _isConnected;

  User? get user => _firebaseAuth.currentUser;

  FirebaseAuth get firebaseAuth => _firebaseAuth;

  FirebaseFirestore get firebaseFirestore => _firebaseFirestore;

  FirebaseDatabase get realtimeDatabase => _realtimeDatabase!;

  FirebaseFunctions get firebaseFunctions => _firebaseFunctions!;

  void _syncStats() async {
    if (isConnected) {
      var prefs = await SharedPreferences.getInstance();

      var data = prefs.getStringList("gameResults");

      if (data != null) {
        for (var i = 0; i < data.length; i++) {
          await firebaseFirestore
              .collection('user_solo_games')
              .doc(user!.uid)
              .collection('gameResults')
              .add(jsonDecode(data[i]));
        }

        prefs.remove("gameResults");

        var stats = await firebaseFirestore
            .collection('user_solo_games')
            .doc(user!.uid)
            .collection('gameResults')
            .orderBy('score', descending: true)
            .limit(30)
            .get();

        var statsList = stats.docs.map((e) => e.data()).toList();

        // divide the stats into 3 pages

        prefs.setStringList(
            "local_stat_sync", statsList.map((e) => jsonEncode(e)).toList());
      }
    }
  }
}
