import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class AdminUserManager extends ChangeNotifier {
  List<UserModel> users = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription? _streamSubscription;

  void updateUser(UserManager userManager) {
    if (_streamSubscription != null) _streamSubscription!.cancel();

    if (userManager.adminEnabled) {
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers() {
    _streamSubscription =
        firestore.collection('users').snapshots().listen((snapshot) {
      users = snapshot.docs
          .map((e) => UserModel.fromJson(json.encode(e.data())))
          .toList();
      users
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  List<String> get names => users.map((user) => user.name).toList();

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
