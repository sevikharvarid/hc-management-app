import 'dart:convert';

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
  int id;
  String code;
  String name;
  int price;
  int minPrice;
  int qty;
  dynamic note;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  Products({
    required this.id,
    required this.code,
    required this.name,
    required this.price,
    required this.minPrice,
    required this.qty,
    required this.note,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        price: json["price"],
        minPrice: json["min_price"],
        qty: json["qty"],
        note: json["note"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "price": price,
        "min_price": minPrice,
        "qty": qty,
        "note": note,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
