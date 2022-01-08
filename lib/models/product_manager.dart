import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProducts();
  }

  final FirebaseFirestore firebasestore = FirebaseFirestore.instance;

  List<Product> _allProducts = [];

  _loadAllProducts() async {
    final QuerySnapshot snapProducts =
        await firebasestore.collection('products').get();

    for (DocumentSnapshot docs in snapProducts.docs) {
      Product p = Product();
      p.fromDocument(docs);
      _allProducts.add(p);
    }
    notifyListeners();
  }
}
