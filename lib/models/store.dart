import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';

class Store {
  String name = "";
  String image = "";
  String phone = "";
  Address address;
  Map<String, dynamic> opening;

  String get addressText =>
      '${address.street}, ${address.number}${address.complement != '' ? ' - ${address.complement} - ' : ''}, ${address.district}, ${address.city}/${address.state}';

  Store({
    required this.name,
    required this.image,
    required this.phone,
    required this.address,
    required this.opening,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'phone': phone,
      'address': address.toMap(),
      'opening': opening,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      phone: map['phone'] ?? '',
      address: Address.fromMap(map['address']),
      opening: (map['opening'] as Map<String, dynamic>).map((key, value) {
        final timesString = value as String;

        if (timesString != "" && timesString.isNotEmpty) {
          final splitted = timesString.split(RegExp(r"[:-]"));
          return MapEntry(
            key,
            {
              "from": TimeOfDay(
                hour: int.parse(splitted[0]),
                minute: int.parse(splitted[1]),
              ),
              "to": TimeOfDay(
                hour: int.parse(splitted[2]),
                minute: int.parse(splitted[3]),
              ),
            },
          );
        } else {
          return MapEntry(key, null);
        }
      }),
    );
  }

  String toJson() => json.encode(toMap());

  factory Store.fromJson(String source) => Store.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Store(name: $name, image: $image, phone: $phone, address: $address, opening: $opening)';
  }
}
