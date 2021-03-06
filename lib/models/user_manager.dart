import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:loja_virtual/helper/firebase_errors.dart';
import 'package:loja_virtual/models/user.dart';

class UserManager extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserModel user = UserModel();

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _loadingFace = false;
  bool get loadingFace => _loadingFace;
  set loadingFace(bool value) {
    _loadingFace = value;
    notifyListeners();
  }

  bool get isLoggedIn => user.id != "";

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

  void facebookLogin({Function? onFail, Function? onSuccess}) async {
    loadingFace = true;
    final result = await FacebookAuth.instance.login();
    switch (result.status) {
      case LoginStatus.success:
        final credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final authResult = await auth.signInWithCredential(credential);
        if (authResult.user != null) {
          final firebaseUser = authResult.user;

          user = UserModel(
            id: firebaseUser!.uid,
            name: firebaseUser.displayName!,
            email: firebaseUser.email!,
          );

          await user.saveData();

          loadingFace = false;
          onSuccess!();
        }
        break;
      case LoginStatus.cancelled:
        loadingFace = false;
        break;
      case LoginStatus.failed:
        loadingFace = false;
        onFail!(result.message);
        break;
      case LoginStatus.operationInProgress:
        loadingFace = true;
        break;
    }
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

  void signOut() {
    auth.signOut();
    user = UserModel();
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User? firebaseUser}) async {
    final User? currentUser = firebaseUser ?? auth.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot snapshot =
          await firestore.collection('users').doc(currentUser.uid).get();
      user = UserModel.fromJson(json.encode(snapshot.data()));

      user.saveToken();

      final docAdmin = await firestore.collection('admins').doc(user.id).get();
      if (docAdmin.exists) {
        user.admin = true;
      }
      // functionsFirebase();

      notifyListeners();
    }
  }

  Future<void> functionsFirebase() async {
    try {
      final response =
          await FirebaseFunctions.instance.httpsCallable('helloWorld').call();
      print(response);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool get adminEnabled => user.id != "" && user.admin;
}
