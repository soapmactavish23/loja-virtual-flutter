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

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
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
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
