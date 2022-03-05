import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';

enum Status { canceled, preparing, transporting, delivery }

class Order {
  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user!.id;
    address = cartManager.address!;
    status = Status.preparing;
  }

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;

    items = (doc['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc['price'] as num;
    userId = doc['user'] as String;
    address = Address.fromMap(doc['address'] as Map<String, dynamic>);
    date = doc['date'] as Timestamp;
    status = Status.values[doc['status'] as int];
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void updateFromDocument(DocumentSnapshot doc) {
    status = Status.values[doc['status'] as int];
  }

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set({
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'address': address.toMap(),
      'status': status.index,
      'date': Timestamp.now(),
    });
  }

  Function()? get back {
    return status.index >= Status.transporting.index
        ? () {
            status = Status.values[status.index - 1];
            firestore
                .collection('orders')
                .doc(orderId)
                .update({'status': status.index});
          }
        : null;
  }

  Function()? get advance {
    return status.index <= Status.transporting.index
        ? () {
            status = Status.values[status.index + 1];
            print(status.index);
            firestore
                .collection('orders')
                .doc(orderId)
                .update({'status': status.index});
          }
        : null;
  }

  String orderId = '';
  List<CartProduct> items = [];
  num price = 0.0;
  String userId = '';
  Address address = Address();
  Status status = Status.preparing;

  Timestamp? date;

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em preparação';
      case Status.transporting:
        return 'Em transporte';
      case Status.delivery:
        return 'Entregue';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'Order(orderId: $orderId, items: $items, price: $price, userId: $userId, date: $date)';
  }
}
