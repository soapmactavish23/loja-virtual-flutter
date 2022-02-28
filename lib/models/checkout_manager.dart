
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/cart_manager.dart';

class CheckoutManager extends ChangeNotifier {

  CartManager? cartManager;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  void checkout() {
    _decrementStock();

    _getOrderId().then((value) => print(value));
  }

  Future<int> _getOrderId() async {
    final ref = firestore.doc('aux/ordercounter');
    try {
      final result = await firestore.runTransaction((tx) async {
      final doc = await tx.get(firestore.doc('aux/ordercounter'));
      final orderId = doc['current'] as int;
      tx.update(ref, {'current': orderId + 1});
      return {'orderId': orderId};
    }); 
    return result['orderId'] as int;
    } catch(e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  void _decrementStock() {

  }
  
}