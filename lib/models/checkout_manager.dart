import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/product.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager? cartManager;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout({Function? onStockFail}) async {
    try {
      await _decrementStock();
    } catch (e) {
      onStockFail!(e);
      return;
    }

    //TODO: PROCESSAR PAGAMENTO
    final orderId = await _getOrderId();

    final order = Order.fromCartManager(cartManager!);
    order.orderId = orderId.toString();

    order.save();
    
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
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  Future<void> _decrementStock() async {
    return await firestore.runTransaction((tx) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for (final cartProduct in cartManager!.items) {
        Product product;

        if (productsToUpdate.any((p) => p.id == cartProduct.productId)) {
          product =
              productsToUpdate.firstWhere((p) => p.id == cartProduct.productId);
        } else {
          final doc = await tx.get(
            firestore.doc('products/${cartProduct.productId}'),
          );
          product = Product.fromDocument(doc);
        }

        cartProduct.product = product;

        final size = product.findSize(cartProduct.size);
        if (size!.stock! - cartProduct.quantity < 0) {
          productsWithoutStock.add(product);
        } else {
          int res = size.stock!;
          res -= cartProduct.quantity;
          size.stock = res;
          productsToUpdate.add(product);
        }
      }

      if (productsWithoutStock.isNotEmpty) {
        return Future.error(
            '${productsWithoutStock.length} produtos sem estoque');
      }

      for (final product in productsToUpdate) {
        tx.update(firestore.doc('products/${product.id}'),
            {'sizes': product.exportSizeList()});
      }
    });
  }
}
