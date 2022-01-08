import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id = "";
  String name = "";
  String description = "";
  List<String> images = [];

  fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document['images'] as List<dynamic>);
  }
}
