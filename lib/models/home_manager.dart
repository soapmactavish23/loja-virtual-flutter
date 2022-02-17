import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/section.dart';

class HomeManager extends ChangeNotifier {
  HomeManager() {
    _loadSections();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Section> sections = [];

  bool editing = false;

  Future<void> _loadSections() async {
    firestore.collection("home").snapshots().listen((snapshot) {
      try {
        sections.clear();
        for (final DocumentSnapshot document in snapshot.docs) {
          sections.add(Section.fromDocument(document));
        }
        notifyListeners();
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  void enterEditing() {
    editing = true;
    notifyListeners();
  }

  void saveEditing() {
    editing = false;
    notifyListeners();
  }

  void discartEditing() {
    editing = false;
    notifyListeners();
  }
}
