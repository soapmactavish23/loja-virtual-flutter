import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/helper/firebase_errors.dart';
import 'package:loja_virtual/models/user.dart';

class UserManager extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserModel user = UserModel();

  bool _loading = false;
  bool get loading => _loading;

  UserManager() {
    _loadCurrentUser();
  }

  Future<void> signIn(
      {required UserModel userModel,
      Function? onFail,
      Function? onSuccess}) async {
    loading = true;
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: userModel.email, password: userModel.password);

      await _loadCurrentUser(firebaseUser: result.user);

      onSuccess!();
    } on FirebaseAuthException catch (e) {
      onFail!(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signUp(
      {UserModel? user, Function? onFail, Function? onSuccess}) async {
    loading = true;
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
          email: user!.email, password: user.password);

      user.id = result.user!.uid;
      this.user = user;
      await user.saveData();

      onSuccess!();
    } on FirebaseAuthException catch (e) {
      onFail!(getErrorString(e.code));
    }
    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User? firebaseUser}) async {
    final User? currentUser = firebaseUser ?? await auth.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot snapshot =
          await firestore.collection('users').doc(currentUser.uid).get();
      this.user = UserModel.fromJson(json.encode(snapshot.data()));

      print(this.user.toMap());
      notifyListeners();
    }
  }
}
