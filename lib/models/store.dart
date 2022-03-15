import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/helper/extensions.dart';

enum StoreStatus { closed, open, closing }

class Store {
  String name = "";
  String image = "";
  String phone = "";
  Address address;
  Map<String, dynamic> opening;

  StoreStatus? status;

  String get addressText =>
      '${address.street}, ${address.number}${address.complement != '' ? ' - ${address.complement} - ' : ''}, ${address.district}, ${address.city}/${address.state}';

  String get openingText {
    final monfri = formattedPeriod(opening['monfri'] ?? {});
    final sunday = formattedPeriod(opening['sunday'] ?? {});
    final saturday = formattedPeriod(opening['saturday'] ?? {});
    return 'Seg-Sex: $monfri\nSáb: $saturday\nDom: $sunday';
  }

  String get cleanPhone => phone.replaceAll(RegExp(r"[^\d]"), "");

  String get statusText {
    switch (status) {
      case StoreStatus.closed:
        return 'Fechada';
      case StoreStatus.open:
        return 'Aberta';
      case StoreStatus.closing:
        return 'Fechando';
      default:
        return '';
    }
  }

  String formattedPeriod(Map<String, dynamic> period) {
    if (period['from'] == null && period['to'] == null) return "Fechada";
    TimeOfDay from = period['from'];
    TimeOfDay to = period['to'];

    return '${from.formatted()} - ${to.formatted()}';
  }

  void updateStatus() {
    final weekday = DateTime.now().weekday;

    Map<String, TimeOfDay> period;
    if (weekday >= 1 && weekday <= 5) {
      period = opening['monfri'] ?? {};
    } else if (weekday == 6) {
      period = opening['saturday'] ?? {};
    } else {
      period = opening['sunday'] ?? {};
    }

    final now = TimeOfDay.now();

    if (period['from'] == null && period['to'] == null) {
      status = StoreStatus.closed;
    } else if (period['from']!.toMinutes() < now.toMinutes() &&
        period['to']!.toMinutes() - 15 > now.toMinutes()) {
      status = StoreStatus.open;
    } else if (period['from']!.toMinutes() < now.toMinutes() &&
        period['to']!.toMinutes() > now.toMinutes()) {
      status = StoreStatus.closing;
    } else {
      status = StoreStatus.closed;
    }
  }

  Store({
    required this.name,
    required this.image,
    required this.phone,
    required this.address,
    required this.opening,
  }) {
    updateStatus();
  }

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
        final timesString = value;

        if (timesString != "" && timesString != null) {
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
