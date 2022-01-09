import 'dart:convert';

class ItemSize {
  String name;
  num price;
  int stock;

  ItemSize({
    this.name = "",
    this.price = 0,
    this.stock = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'stock': stock,
    };
  }

  factory ItemSize.fromMap(Map<String, dynamic> map) {
    return ItemSize(
      name: map['name'] as String,
      price: map['price'] as num,
      stock: map['stock'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemSize.fromJson(String source) =>
      ItemSize.fromMap(json.decode(source));

  @override
  String toString() => 'ItemSize(name: $name, price: $price, stock: $stock)';
}
