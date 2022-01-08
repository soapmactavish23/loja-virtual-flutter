import 'package:cloud_firestore/cloud_firestore.dart';

class ProductManager {
  ProductManager() {
    _loadAllProducts();
  }

  final FirebaseFirestore firebasestore = FirebaseFirestore.instance;

  _loadAllProducts() async {
    final QuerySnapshot snapProducts = await firebasestore.collection('products').get();
    for(DocumentSnapshot doc in snapProducts.docs) {
      print(doc.data());
    }
  }
}
