import 'dart:convert';


DataSpg dataSpgFromJson(String str) => DataSpg.fromJson(json.decode(str));

String dataSpgToJson(DataSpg data) => json.encode(data.toJson());

class DataSpg {
  int id;
  int spvId;
  String spvName;
  int userId;
  String userName;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  DataSpg({
    required this.id,
    required this.spvId,
    required this.spvName,
    required this.userId,
    required this.userName,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataSpg.fromJson(Map<String, dynamic> json) => DataSpg(
        id: json["id"],
        spvId: json["spv_id"],
        spvName: json["spv_name"],
        userId: json["user_id"],
        userName: json["user_name"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "spv_id": spvId,
        "spv_name": spvName,
        "user_id": userId,
        "user_name": userName,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
