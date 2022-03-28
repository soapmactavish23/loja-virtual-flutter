import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loja_virtual/models/address.dart';

class UserModel {
  String id;
  String name;
  String email;
  String cpf;
  String password;
  String confirmPassword = "";

  bool admin = false;

  Address? address;

  UserModel(
      {this.id = "",
      this.email = "",
      this.password = "",
      this.name = "",
      this.cpf = ""});

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.collection('users').doc(id);

  CollectionReference get cartReference => firestoreRef.collection("cart");

  CollectionReference get tokensReference => firestoreRef.collection("token");

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    email = document['email'] as String;
    if (document['address'] != null) {
      address = Address.fromJson(json.encode(document['address']));
    }
  }

  void setAddress(Address address) {
    this.address = address;
    saveData();
  }

  void setCpf(String cpf) {
    this.cpf = cpf;
    saveData();
  }

  Future<void> saveToken() async {
    final messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    await tokensReference.doc(token).set({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (cpf != '') 'cpf': cpf,
      if (address != null) 'address': address!.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    UserModel u = UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
    if (map['cpf'] != null) {
      u.cpf = map['cpf'] as String;
    }
    if (map['address'] != null) {
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
