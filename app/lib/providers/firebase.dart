import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseDatabase _realtimeDatabase;
  final FirebaseFunctions _firebaseFunctions;

  User? _user;

  FirebaseProvider(
    this._firebaseAuth,
    this._firebaseFirestore,
    this._realtimeDatabase,
    this._firebaseFunctions,
  ) {
    _firebaseAuth.authStateChanges().listen((User? user) {
      _user = user;

      notifyListeners();
    });
  }

  User? get user => _user;

  FirebaseAuth get firebaseAuth => _firebaseAuth;

  FirebaseFirestore get firebaseFirestore => _firebaseFirestore;

  FirebaseDatabase get realtimeDatabase => _realtimeDatabase;

  FirebaseFunctions get firebaseFunctions => _firebaseFunctions;
}
