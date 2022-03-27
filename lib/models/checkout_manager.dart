import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/services/cielo_payment.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager? cartManager;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CieloPayment cieloPayment = CieloPayment();

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout(
      {required CreditCard creditCard,
      Function? onStockFail,
      Function? onSuccess,
      Function(String)? onPayFail}) async {
    loading = true;

    final orderId = await _getOrderId();

    try {
      String payId = await cieloPayment.authorize(
        creditCard: creditCard,
        price: cartManager!.totalPrice,
        orderId: orderId.toString(),
        user: cartManager!.user!,
      );
      debugPrint('Success $payId');
    } catch (e) {
      onPayFail!(e.toString());
      loading = false;
      return;
    }

    try {
      await _decrementStock();
    } catch (e) {
      onStockFail!(e);
      loading = false;
      return;
    }

    // final order = Order.fromCartManager(cartManager!);
    // order.orderId = orderId.toString();

    // await order.save();

    // cartManager!.clear();
    // onSuccess!(order);
    loading = false;
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
