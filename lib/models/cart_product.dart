import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';

class CartProduct {
  CartProduct.fromProduct(this.product) {
    productId = product!.id;
    quantity = 1;
    size = product!.selectedSize!.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    productId = document["pid"] as String;
    quantity = document["quantity"] as int;
    size = document['size'] as String;

    firestore
        .doc("product/$productId")
        .get()
        .then((doc) => product = Product.fromDocument(doc));
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String productId = '';
  int quantity = 1;
  String size = '';

  Product? product;

  ItemSize? get itemSize {
    if (product == null) return null;
    return product!.findSize(size);
  }

  num get unitPrice {
    if (product == null) return 0;
    return itemSize?.price ?? 0;
  }

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize!.name == size;
  }
}
