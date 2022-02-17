import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  String id = "";
  String name = "";
  String description = "";
  List<dynamic>? images = [];
  List<ItemSize>? sizes = [];

  List<dynamic>? newImages = [];

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

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('products/$id');
  Reference get storageRef => storage.ref('products').child(id);

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

  List<Map<String, dynamic>> exportSizeList() {
    return sizes!.map((size) => size.toMap()).toList();
  }

  Future<void> save() async {
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
    };

    if (id == "") {
      final doc = await firestore.collection('products').add(data);
      id = doc.id;
    } else {
      firestoreRef.update(data);
    }

    final List<String> updateImages = [];

    for (final newImage in newImages!) {
      if (images!.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        UploadTask task =
            storageRef.child(const Uuid().v1()).putFile(newImage as File);
        final TaskSnapshot snapshot = await task.then((p0) => p0);
        final String url = await snapshot.ref.getDownloadURL();
        updateImages.add(url);
      }
    }

    notifyListeners();
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
    return 'Product(id: $id, name: $name, description: $description, images: $images, sizes: $sizes, newImages: $newImages)';
  }
}
