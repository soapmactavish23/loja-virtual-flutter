
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class StoresManager extends ChangeNotifier {

  StoresManager() {
    _loadStoreList();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _loadStoreList() async {

    final snapshot = await firestore.collection('stores').get();

    print(snapshot.docs.first.data());

    notifyListeners();

  }
  
}