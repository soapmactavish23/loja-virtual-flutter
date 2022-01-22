import 'package:cloud_firestore/cloud_firestore.dart';

class Section {

  String name = "";
  String type = "";

  Section.fromDocument(DocumentSnapshot document) {
    name = document['name'] as String;
    type = document['type'] as String;
  }


  @override
  String toString() => 'Section(name: $name, type: $type)';
}
