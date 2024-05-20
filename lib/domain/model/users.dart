import 'dart:convert';

import 'package:hc_management_app/domain/model/stores.dart';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  bool success;
  String message;
  Data data;
  DataStore? store;

  Users({
    required this.success,
    required this.message,
    required this.data,
    required this.store,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        store: json["store"] != null ? DataStore.fromJson(json["store"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
        "store": store?.toJson(),
      };
}

class Data {
  int id;
  String name;
  String notes;
  dynamic emailVerifiedAt;
  String nik;
  String? photo;
  String type;
  dynamic createdBy;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.name,
    required this.notes,
    required this.emailVerifiedAt,
    required this.nik,
    required this.type,
    required this.photo,
    required this.createdBy,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        notes: json["notes"],
        emailVerifiedAt: json["email_verified_at"],
        nik: json["nik"],
        photo: json["photo"],
        type: json["type"],
        createdBy: json["created_by"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "notes": notes,
        "email_verified_at": emailVerifiedAt,
        "nik": nik,
        "photo": photo,
        "type": type,
        "created_by": createdBy,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
