import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:loja_virtual/models/section_item.dart';

class Section extends ChangeNotifier {
  String name = "";
  String type = "";
  List<SectionItem> items = [];

  String _error = "";
  String get error => _error;
  set error(String value) {
    _error = value;
    notifyListeners();
  }

  Section({
    this.name = "",
    this.type = "",
    required this.items,
  });

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  Section.fromDocument(DocumentSnapshot document) {
    name = document['name'] as String;
    type = document['type'] as String;
    items =
        (document['items'] as List).map((i) => SectionItem.fromMap(i)).toList();
  }

  bool valid() {
    if(name == '' || name.isEmpty) {
      error = 'Título inválido';
    } else if(items.isEmpty) {
      error = 'Insira ao menos uma imagem';
    } else {
      error = '';
    }
    notifyListeners();
    return error == '';
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
