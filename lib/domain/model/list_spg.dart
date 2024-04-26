import 'dart:convert';

ListSpg listSpgFromJson(String str) => ListSpg.fromJson(json.decode(str));

String listSpgToJson(ListSpg data) => json.encode(data.toJson());

class ListSpg {
  bool success;
  String message;
  DataSPG data;

  ListSpg({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ListSpg.fromJson(Map<String, dynamic> json) => ListSpg(
        success: json["success"],
        message: json["message"],
        data: DataSPG.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class DataSPG {
  int currentPage;
  List<DataListSPG> data;
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

  DataSPG({
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

  factory DataSPG.fromJson(Map<String, dynamic> json) => DataSPG(
        currentPage: json["current_page"],
        data: List<DataListSPG>.from(
            json["data"].map((x) => DataListSPG.fromJson(x))),
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

class DataListSPG {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  String nik;
  String type;
  String? role;
  String createdBy;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  DataListSPG({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.nik,
    required this.type,
    required this.role,
    required this.createdBy,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataListSPG.fromJson(Map<String, dynamic> json) => DataListSPG(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        nik: json["nik"],
        type: json["type"],
        role: json["role"],
        createdBy: json["created_by"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "nik": nik,
        "type": type,
        "role": role,
        "created_by": createdBy,
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
