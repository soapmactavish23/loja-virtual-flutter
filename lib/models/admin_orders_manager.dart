import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class AdminOrdersManager extends ChangeNotifier {
  UserModel user = UserModel();

  List<Order> orders = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription? _subscription;

  void updateAdmin(bool adminEnabled) {
    orders.clear();

    _subscription?.cancel();
    if (adminEnabled) {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    _subscription = firestore.collection('orders').snapshots().listen(
      (event) {
        orders.clear();
        for (final doc in event.docs) {
          orders.add(Order.fromDocument(doc));
        }
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
