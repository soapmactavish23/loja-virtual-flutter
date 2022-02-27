import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';

class UserModel {
  String id;
  String name;
  String email;
  String password;
  String confirmPassword = "";

  bool admin = false;

  Address? address;

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
    if(document['address'] != null) {
      address = Address.fromJson(json.encode(document['address']));
    }
  }

  void setAddress(Address address) {
    this.address = address;
    saveData();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if(address != null)
        'address': address!.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    UserModel u = UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
    if(map['address'] != null) {
      u.address = Address.fromJson(json.encode(map['address']));
    }
    return u;
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, password: $password, confirmPassword: $confirmPassword, admin: $admin)';
  }
}
