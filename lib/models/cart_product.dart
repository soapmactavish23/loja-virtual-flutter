import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';

class CartProduct {
  CartProduct.fromProduct(this.product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize!.name;
  }

  String productId = '';
  int quantity = 1;
  String size = '';

  Product product;
}
