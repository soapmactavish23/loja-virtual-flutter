import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/services/via_cep_service.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  UserModel? user;
  Address? address;

  num productsPrice = 0.0;

  void updateUser(UserManager userManager) {
    user = userManager.user;
    items.clear();

    if (user != null) {
      _loadCartItems();
    }
  }

  _loadCartItems() async {
    try {
      final QuerySnapshot cartSnap = await user!.cartReference.get();
      items = cartSnap.docs
          .map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated))
          .toList();
    } catch (e) {
      debugPrint("CartManager: $e");
    }
  }

  void addToCart(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user!.cartReference
          .add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.id);
      _onItemUpdated();
    }
    notifyListeners();
  }

  void _onItemUpdated() {
    productsPrice = 0.0;

    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];

      if (cartProduct.quantity == 0) {
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;

      _updatedCartProduct(cartProduct);
    }

    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    user!.cartReference.doc(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  void _updatedCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != '') {
      try {
        user!.cartReference
            .doc(cartProduct.id)
            .update(cartProduct.toCartItemMap());
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }

  Future<void> getAddress(String cep) async {
    final cepAbertoService = ViaCepService();
    try {
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      if (cepAbertoAddress != null) {
        address = Address(
          street: cepAbertoAddress.logradouro,
          district: cepAbertoAddress.bairro,
          zipCode: cepAbertoAddress.cep,
          city: cepAbertoAddress.cidade.nome,
          state: cepAbertoAddress.estado.sigla,
          lat: cepAbertoAddress.latitude,
          long: cepAbertoAddress.longitude,
        );
        print(address!.district);
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
