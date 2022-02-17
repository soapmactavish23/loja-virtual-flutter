import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:loja_virtual/models/section_item.dart';

class Section {
  String name = "";
  String type = "";
  List<SectionItem> items = [];

  Section({
    required this.name,
    required this.type,
    required this.items,
  });

  Section.fromDocument(DocumentSnapshot document) {
    name = document['name'] as String;
    type = document['type'] as String;
    items =
        (document['items'] as List).map((i) => SectionItem.fromMap(i)).toList();
  }

  Section clone() {
    return Section(
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList(),
    );
  }

  @override
  String toString() => 'Section(name: $name, type: $type, items: $items)';
}
