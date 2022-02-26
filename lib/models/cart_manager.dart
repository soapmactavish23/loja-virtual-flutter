import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
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
  num deliveryPrice = 0.0;
  num get totalPrice => productsPrice + deliveryPrice;

  bool _loading = false;

  bool get loading => _loading;
  set(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  bool get isAddressValid => address != null && deliveryPrice != 0.0;

  Future<void> getAddress(String cep) async {
    final cepAbertoService = ViaCepService();
    _loading = true;
    try {
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      // ignore: unnecessary_null_comparison
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
      }
    } catch (e) {
      _loading = false;
      notifyListeners();
      return Future.error(e);
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> setAddress(Address address) async {
    this.address = address;
    _loading = true;
    if (await calculateDelivery(address.lat!, address.long!)) {
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
      return Future.error('Endereço fora do raio de entrega :(');
    }
    
  }

  void removeAddress() {
    address = null;
    deliveryPrice = 0.0;
    notifyListeners();
  }

  Future<bool> calculateDelivery(double lat, double long) async {
    final DocumentSnapshot doc = await firestore.doc('aux/delivery').get();
    final latStore = doc['lat'] as double;
    final longStore = doc['long'] as double;
    final base = doc['base'] as num;
    final km = doc['km'] as num;
    final maxkm = doc['maxkm'] as num;

    double dis = Geolocator.distanceBetween(latStore, longStore, lat, long);

    dis /= 1000.0;

    debugPrint('Distance $dis');

    if (dis > maxkm) {
      return false;
    }

    deliveryPrice = base + dis * km;
    return true;
  }
}
