import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/store.dart';

class StoresManager extends ChangeNotifier {
  StoresManager() {
    _loadStoreList();
    _startTime();
  }

  List<Store> stores = [];
  Timer? _timer;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _loadStoreList() async {
    final snapshot = await firestore.collection('stores').get();

    stores = snapshot.docs.map((store) => Store.fromMap(store.data())).toList();

    notifyListeners();
  }

  void _startTime() {
    _timer = Timer.periodic(
        const Duration(
          minutes: 1,
        ), (timer) {
      _checkOpening();
    });
  }

  void _checkOpening() {
    for (final store in stores) {
      store.updateStatus();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
