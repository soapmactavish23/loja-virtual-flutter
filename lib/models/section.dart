import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:loja_virtual/models/section_item.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier {
  String id = "";
  String name = "";
  String type = "";
  List<SectionItem> items = [];
  List<SectionItem> originalItems = [];

  String _error = "";
  String get error => _error;
  set error(String value) {
    _error = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('home/$id');
  Reference get storageRef => storage.ref().child('home').child(id);

  Section({
    this.id = '',
    this.name = "",
    this.type = "",
    required this.items,
  }) {
    originalItems = List.from(items);
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  Section.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    type = document['type'] as String;
    items =
        (document['items'] as List).map((i) => SectionItem.fromMap(i)).toList();
  }

  Future<void> save(int pos) async {
    Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'pos': pos,
    };

    if (id == '') {
      final doc = await firestore.collection('home').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    for (final item in items) {
      if (item.image is File) {
        UploadTask task =
            storageRef.child(const Uuid().v1()).putFile(item.image as File);
        TaskSnapshot snapshot =
            await task.then((TaskSnapshot snapshot) => snapshot);
        final String url = await snapshot.ref.getDownloadURL();
        item.image = url;
      }
    }

    for (final original in originalItems) {
      if (!items.contains(original)) {
        try {
          final ref = storage.refFromURL(original.image);
          await ref.delete();
        } catch (e) {
          debugPrint('Falha ao deletar: $original');
        }
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((e) => e.toMap()).toList(),
    };

    await firestoreRef.update(itemsData);
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for (final item in items) {
      try {
        final ref = storage.refFromURL(item.image as String);
        await ref.delete();
      } catch (e) {
        debugPrint('Falha ao deletar $item');
      }
    }
  }

  bool valid() {
    if (name == '' || name.isEmpty) {
      error = 'Título inválido';
    } else if (items.isEmpty) {
      error = 'Insira ao menos uma imagem';
    } else {
      error = '';
    }
    notifyListeners();
    return error == '';
  }

  Section clone() {
    return Section(
      id: id,
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList(),
    );
  }

  @override
  String toString() => 'Section(name: $name, type: $type, items: $items)';
}
