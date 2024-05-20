import 'dart:convert';

Absence absenceFromJson(String str) => Absence.fromJson(json.decode(str));

String absenceToJson(Absence data) => json.encode(data.toJson());

class Absence {
  int id;
  int storeId;
  String storeName;
  DateTime date;
  String time;
  String type;
  String image;
  String latt;
  String long;
  String spgName;
  String userLogin;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  Absence({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.date,
    required this.time,
    required this.type,
    required this.image,
    required this.latt,
    required this.long,
    required this.spgName,
    required this.userLogin,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Absence.fromJson(Map<String, dynamic> json) => Absence(
        id: json["id"],
        storeId: json["store_id"],
        storeName: json["store_name"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        type: json["type"],
        image: json["image"],
        latt: json["latt"],
        long: json["long"],
        spgName: json["spg_name"],
        userLogin: json["user_login"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_id": storeId,
        "store_name": storeName,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "type": type,
        "image": image,
        "latt": latt,
        "long": long,
        "spg_name": spgName,
        "user_login": userLogin,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
