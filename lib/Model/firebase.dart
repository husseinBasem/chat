import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBase {
  final _fireStore = FirebaseFirestore.instance;

  Future getUserByUserName(String user) async {
    return await _fireStore
        .collection('users')
        .where('User', isEqualTo: user)
        .get;
  }

  Future getUserByEmail(String email) async {
    return await _fireStore
        .collection('users')
        .where('User', isEqualTo: email)
        .get();
  }
}
