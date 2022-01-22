import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  String password;
  String confirmPassword = "";

  UserModel(
      {this.id = "", this.email = "", this.password = "", this.name = ""});

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.collection('users').doc(id);

  CollectionReference get cartReference => firestoreRef.collection("cart");

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    email = document['email'] as String;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
