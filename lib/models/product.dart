import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:loja_virtual/models/item_size.dart';

class Product extends ChangeNotifier {
  String id = "";
  String name = "";
  String description = "";
  List<dynamic>? images = [];
  List<ItemSize>? sizes = [];

  ItemSize? _selectedSize = null;

  ItemSize? get selectedSize => _selectedSize;

  Product(
      {this.id = "", this.name = "", this.description = "", images, sizes}) {
    debugPrint(images.toString());
    this.images = images ?? [];
    this.sizes = sizes ?? [];
  }

  set selectedSize(item) {
    _selectedSize = item;
    notifyListeners();
  }

  Product.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document['images'] as List<dynamic>);
    sizes = (document['sizes'] as List<dynamic>)
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  int get totalStocks {
    int stock = 0;
    for (final size in sizes!) {
      stock += size.stock!;
    }
    return stock;
  }

  bool get hasStock {
    return totalStocks > 0;
  }

  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes!) {
      if (size.price! < lowest && size.hasStock) {
        lowest = size.price!;
      }
    }
    return lowest;
  }

  ItemSize? findSize(String name) {
    try {
      return sizes!.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images!),
      sizes: sizes!.map((size) => size.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, images: $images, sizes: $sizes, _selectedSize: $_selectedSize)';
  }
}
