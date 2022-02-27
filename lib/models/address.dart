import 'dart:convert';

class Address {
  String? street;
  String? number;
  String? complement;
  String? district;
  String? zipCode;
  String? city;
  String? state;

  double? lat;
  double? long;

  Address({
    this.street,
    this.number,
    this.complement,
    this.district,
    this.zipCode,
    this.city,
    this.state,
    this.lat,
    this.long
  });

  @override
  String toString() {
    return 'Address(street: $street, number: $number, complement: $complement, district: $district, zipCode: $zipCode, city: $city, state: $state, lat: $lat, long: $long)';
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'number': number,
      'complement': complement,
      'district': district,
      'zipCode': zipCode,
      'city': city,
      'state': state,
      'lat': lat,
      'long': long,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'],
      number: map['number'],
      complement: map['complement'],
      district: map['district'],
      zipCode: map['zipCode'],
      city: map['city'],
      state: map['state'],
      lat: map['lat']?.toDouble(),
      long: map['long']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) => Address.fromMap(json.decode(source));
}
