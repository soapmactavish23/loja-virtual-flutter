import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/section.dart';

class HomeManager {
  HomeManager() {
    _loadSections();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Section> sections = [];

  Future<void> _loadSections() async {
    firestore.collection("home").snapshots().listen((snapshot) {
      try {
        sections.clear();
        for (final DocumentSnapshot document in snapshot.docs) {
          sections.add(Section.fromDocument(document));
        }
        print(sections);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    });
  }
}
