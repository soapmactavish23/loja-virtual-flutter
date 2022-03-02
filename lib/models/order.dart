import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';

class Order {
  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user!.id;
    address = cartManager.address!;
  }

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;

    items = (doc['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc['price'] as num;
    userId = doc['user'] as String;
    address = Address.fromMap(doc['address'] as Map<String, dynamic>);
    // date = doc['date'] as Timestamp;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set({
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'address': address.toMap(),
    });
  }

  String orderId = '';
  List<CartProduct> items = [];
  num price = 0.0;
  String userId = '';
  Address address = Address();

  Timestamp? date;

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  @override
  String toString() {
    return 'Order(orderId: $orderId, items: $items, price: $price, userId: $userId, date: $date)';
  }
}
