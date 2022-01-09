import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/item_size.dart';

class Product {
  String id = "";
  String name = "";
  String description = "";
  List<String> images = [];
  List<ItemSize> sizes = [];

  fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document['images'] as List<dynamic>);
    sizes = (document['sizes'] as List<dynamic>)
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();

    print(sizes);
  }
}
