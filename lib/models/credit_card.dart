import 'dart:convert';

import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CreditCard {
  String number = "";
  String holder = "";
  String expirationDate = "";
  String securityCode = "";
  String brand = "";

  CreditCard({
    this.number = "",
    this.holder = "",
    this.expirationDate = "",
    this.securityCode = "",
    this.brand = "",
  });

  void setHolder(String? name) => holder = name!;
  void setExpirationDate(String? date) => expirationDate = date!;
  void setCVV(String? cvv) => securityCode = cvv!;
  void setNumber(String? number) {
    this.number = number!;
    brand = detectCCType(number.replaceAll(' ', ''))
        .toString()
        .toUpperCase()
        .split(".")
        .last;
  }

  @override
  String toString() {
    return 'CreditCard(number: $number, holder: $holder, expirationDate: $expirationDate, securityCode: $securityCode, brand: $brand)';
  }

  Map<String, dynamic> toMap() {
    return {
      'cardNumber': number.replaceAll(' ', ''),
      'holder': holder,
      'expirationDate': expirationDate,
      'securityCode': securityCode,
      'brand': brand,
    };
  }

  factory CreditCard.fromMap(Map<String, dynamic> map) {
    return CreditCard(
      number: map['number'] ?? '',
      holder: map['holder'] ?? '',
      expirationDate: map['expirationDate'] ?? '',
      securityCode: map['securityCode'] ?? '',
      brand: map['brand'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CreditCard.fromJson(String source) =>
      CreditCard.fromMap(json.decode(source));
}
