// To parse this JSON data, do
//
//     final storeList = storeListFromJson(jsonString);

import 'dart:convert';

StoreList storeListFromJson(String str) => StoreList.fromJson(json.decode(str));

String storeListToJson(StoreList data) => json.encode(data.toJson());

class StoreList {
  bool success;
  String message;
  Data data;

  StoreList({
    required this.success,
    required this.message,
    required this.data,
  });

  factory StoreList.fromJson(Map<String, dynamic> json) => StoreList(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int currentPage;
  List<DataStore> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<DataStore>.from(
            json["data"].map((x) => DataStore.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class DataStore {
  int id;
  int userId;
  String name;
  String code;
  dynamic note1;
  dynamic note2;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  DataStore({
    required this.id,
    required this.userId,
    required this.name,
    required this.code,
    required this.note1,
    required this.note2,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataStore.fromJson(Map<String, dynamic> json) => DataStore(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        code: json["code"],
        note1: json["note1"],
        note2: json["note2"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "code": code,
        "note1": note1,
        "note2": note2,
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
