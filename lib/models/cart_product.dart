import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';

class CartProduct extends ChangeNotifier {
  CartProduct.fromProduct(this._product) {
    productId = product!.id;
    quantity = 1;
    size = product!.selectedSize!.name!;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.id;
    productId = document["pid"] as String;
    quantity = document["quantity"] as int;
    size = document['size'] as String;

    firestore.doc("products/$productId").get().then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  CartProduct.fromMap(Map<String, dynamic> map) {
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as String;
    fixedPrice = map['fixedPrice'] as num;

    firestore.doc("products/$productId").get().then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id = '';
  String productId = '';
  int quantity = 1;
  String size = '';

  num fixedPrice = 0.0;

  Product? _product;
  Product? get product => _product;
  set product(Product? value) {
    _product = value;
    notifyListeners();
  }

  ItemSize? get itemSize {
    if (product == null) return null;
    return product!.findSize(size);
  }

  num get unitPrice {
    if (product == null) return 0;
    return itemSize?.price ?? 0;
  }

  num get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPrice == 0.0 ? unitPrice : fixedPrice,
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize!.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    final size = itemSize;
    if (size == null) return false;
    return size.stock! >= quantity;
  }

  @override
  String toString() {
    return 'CartProduct(productId: $productId, quantity: $quantity, size: $size, product: $product)';
  }
}
