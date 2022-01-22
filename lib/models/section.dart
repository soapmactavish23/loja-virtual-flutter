import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:loja_virtual/models/section_item.dart';

class Section {

  String name = "";
  String type = "";
  List<SectionItem> items = [];

  Section.fromDocument(DocumentSnapshot document) {
    name = document['name'] as String;
    type = document['type'] as String;
    items = (document['items'] as List).map((i) => SectionItem.fromMap(i)).toList();
  }

  @override
  String toString() => 'Section(name: $name, type: $type, items: $items)';
}
