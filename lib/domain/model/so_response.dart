class MapResponseSo {
  int? id;
  dynamic visitId;
  dynamic storeId;
  dynamic storeName;
  dynamic storeCode;
  dynamic userId;
  dynamic userName;
  String? soCode;
  dynamic refNo;
  List<ProductEntity>? products;
  int? totalPrice;
  int? totalQty;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  MapResponseSo({
    this.id,
    this.visitId,
    this.storeId,
    this.storeName,
    this.storeCode,
    this.userId,
    this.userName,
    this.soCode,
    this.refNo,
    this.products,
    this.totalPrice,
    this.totalQty,
    this.createdAt,
    this.deletedAt,
    this.updatedAt,
  });

  factory MapResponseSo.fromJson(Map<String, dynamic> json) => MapResponseSo(
        id: json["id"],
        visitId: json["visit_id"],
        storeId: json["store_id"],
        storeName: json["store_name"],
        storeCode: json["store_code"],
        userId: json["user_id"],
        userName: json["user_name"],
        soCode: json["so_code"],
        refNo: json["ref_no"],
        products: json["products"] != null
            ? List<ProductEntity>.from(
                json["products"].map((x) => ProductEntity.fromJson(x)))
            : [],
        totalPrice: json["total_price"],
        totalQty: json["total_qty"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "visit_id": visitId,
        "store_id": storeId,
        "store_name": storeName,
        "store_code": storeCode,
        "user_id": userId,
        "user_name": userName,
        "so_code": soCode,
        "ref_no": refNo,
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
        "total_price": totalPrice,
        "total_qty": totalQty,
        "deleted_at": deletedAt,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class MapProductEntity {
  String? refNo;
  List<ProductEntity>? products;
  int? totalQty;
  int? totalPrice;
  String? visitId;
  String? userId;
  String? storeId;
  String? stockId;

  MapProductEntity({
    required this.refNo,
    required this.products,
    required this.totalQty,
    required this.totalPrice,
    required this.visitId,
    required this.userId,
    required this.storeId,
    this.stockId,
  });

  factory MapProductEntity.fromJson(Map<String, dynamic> json) =>
      MapProductEntity(
        refNo: json["ref_no"],
        products: List<ProductEntity>.from(
            json["products"].map((x) => ProductEntity.fromJson(x))),
        totalQty: json["total_qty"],
        totalPrice: json["total_price"],
        visitId: json["visit_id"],
        storeId: json["store_id"],
        userId: json["user_id"],
        stockId: json["stockId"],
      );

  Map<String, dynamic> toJson() => {
        "ref_no": refNo,
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
        "total_qty": totalQty,
        "total_price": totalPrice,
        "visit_id": visitId,
        "store_id": storeId,
        "user_id": userId,
        "stockId": stockId,
      };
}

class ProductEntity {
  int? id;
  String? name;
  int? qty;
  int? price;

  ProductEntity({
    required this.id,
    required this.name,
    required this.qty,
    required this.price,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) => ProductEntity(
        id: json["id"],
        name: json["name"],
        qty: json["qty"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "qty": qty,
        "price": price,
      };
}
