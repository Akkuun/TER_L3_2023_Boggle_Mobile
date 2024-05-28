import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseProvider {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseDatabase? _realtimeDatabase;
  final FirebaseFunctions? _firebaseFunctions;

  FirebaseProvider(
    this._firebaseAuth,
    this._firebaseFirestore,
    this._realtimeDatabase,
    this._firebaseFunctions,
  );

  User? get user => _firebaseAuth.currentUser;

  FirebaseAuth get firebaseAuth => _firebaseAuth;

  FirebaseFirestore get firebaseFirestore => _firebaseFirestore;

  FirebaseDatabase get realtimeDatabase => _realtimeDatabase!;

  FirebaseFunctions get firebaseFunctions => _firebaseFunctions!;

  void syncStats() async {
    if (_firebaseAuth.currentUser != null) {
      var prefs = await SharedPreferences.getInstance();

      var data = prefs.get("stats-unsynced");

      if (data != null) {
        if (data is List) {
          for (var i = 0; i < data.length; i++) {
            await _firebaseFirestore
                .collection("stats")
                .doc(_firebaseAuth.currentUser!.uid)
                .update({"$i": data[i]});
          }
        }

        prefs.remove("stats-unsynced");
      }
    }
  }

  Future<dynamic> getStats(int page) async {
    var prefs = await SharedPreferences.getInstance();

    if (page > 5) {
      //online only
      if (_firebaseAuth.currentUser != null) {
        //get 20 stats at a time
        var stats = await _firebaseFirestore
            .doc(user!.uid)
            .collection("stats")
            .limit(20)
            .orderBy("score", descending: true)
            .startAfter([page * 20]).get();

        return stats;
      } else {
        var data = prefs.get("stats-unsynced");
        if (data != null) {
          if (data is List) {
            return data;
          }
        } else {
          if (_firebaseAuth.currentUser == null) {
            return prefs.get("stats-$page");
          }
        }
      }
    }
  }
}
