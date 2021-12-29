import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/helper/firebase_errors.dart';
import 'package:loja_virtual/models/user.dart';

class UserManager extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User user;

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

      user = result.user!;

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

  Future<void> _loadCurrentUser() async {
    final User? currentUser = await auth.currentUser;
    if (currentUser != null) {
      user = currentUser;
      print("aqui $user.uid");
    }
    notifyListeners();
  }
}
