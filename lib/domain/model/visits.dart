class VisitData {
  final int? id;
  final int? storeId;
  final String? storeName;
  final String? storeCode;
  final String? note;
  // final List<String>? image;
  final String? image;
  final String? inDate;
  final String? inTime;
  // final double? inLat;
  // final double? inLong;
  final String? inLat;
  final String? inLong;
  final String? outDate;
  final String? outTime;
  // final double? outLat;
  // final double? outLong;
  final String? outLat;
  final String? outLong;
  final String? userLogin;
  // final UserLogin? userLogin;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? soCode;

  VisitData({
    this.id,
    this.storeId,
    this.storeName,
    this.storeCode,
    this.note,
    this.image,
    this.inDate,
    this.inTime,
    this.inLat,
    this.inLong,
    this.outDate,
    this.outTime,
    this.outLat,
    this.outLong,
    this.userLogin,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.soCode,
  });

  factory VisitData.fromJson(Map<String, dynamic> json) {
    return VisitData(
      id: json['id'],
      storeId: json['store_id'] is int
          ? json['store_id']
          : int.parse(json['store_id']),
      storeName: json['store_name'],
      storeCode: json['store_code'],
      note: json['note'],
      image: json['image'],
      // image: List<String>.from(json['image']),
      // image:
      // json['image'] != null ? List<String>.from(json['image']) : <String>[],
      inDate: json['in_date'],
      inTime: json['in_time'],
      // inLat: json['in_lat'] != null ? double.parse(json['in_lat']) : null,
      // inLong: json['in_long'] != null ? double.parse(json['in_long']) : null,
      inLat: json['in_lat'],
      inLong: json['in_long'],

      outDate: json['out_date'],
      outTime: json['out_time'],
      outLat: json['out_lat'],
      outLong: json['out_long'],
      // outLat: json['out_lat'] != null ? double.parse(json['out_lat']) : null,
      // outLong: json['out_long'] != null ? double.parse(json['out_long']) : null,
      // userLogin: json['user_login'] != null
      //     ? UserLogin.fromJson(json['user_login'])
      //     : null,
      userLogin: json['user_login'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      soCode: json['so_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'store_name': storeName,
      'store_code': storeCode,
      'note': note,
      'image': image,
      'in_date': inDate,
      'in_time': inTime,
      'in_lat': inLat,
      'in_long': inLong,
      'out_date': outDate,
      'out_time': outTime,
      'out_lat': outLat,
      'out_long': outLong,
      'user_login': userLogin,
      // 'user_login': userLogin?.toJson(),
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'so_code': soCode,
    };
  }
}

class UserLogin {
  final String? userId;
  final String? userName;
  final String? userType;

  UserLogin({
    this.userId,
    this.userName,
    this.userType,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      userId: json['user_id'],
      userName: json['user_name'],
      userType: json['user_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_type': userType,
    };
  }
}
