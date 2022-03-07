import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/user.dart';

class OrdersManager extends ChangeNotifier {
  UserModel user = UserModel();

  List<Order> orders = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription? _subscription;

  void updateUser(UserModel user) {
    this.user = user;
    orders.clear();

    _subscription?.cancel();
    if (user.id != "") {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    _subscription = firestore
        .collection('orders')
        .where('user', isEqualTo: user.id)
        .snapshots()
        .listen(
      (event) {
        for (final change in event.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              orders.add(Order.fromDocument(change.doc));
              break;
            case DocumentChangeType.modified:
              final modOrder =
                  orders.firstWhere((o) => o.orderId == change.doc.id);
              modOrder.updateFromDocument(change.doc);
              break;
            case DocumentChangeType.removed:
              debugPrint('Deu problema sério!!!');
              break;
          }
          notifyListeners();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
