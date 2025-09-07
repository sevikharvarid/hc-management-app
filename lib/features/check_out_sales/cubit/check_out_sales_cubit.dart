import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hc_management_app/domain/model/products.dart';
import 'package:hc_management_app/domain/model/so_response.dart';
import 'package:hc_management_app/domain/model/visits.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/features/check_in/repository/check_in_repository.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';
import 'package:http/http.dart' as http;

part 'check_out_sales_state.dart';

class CheckOutSalesCubit extends Cubit<CheckOutSalesState> {
  Map<String, dynamic>? data;

  CheckOutSalesCubit(this.data) : super(CheckOutSalesLoading());

  GeneralHelper generalHelper = GeneralHelper();
  Preferences preferences = Preferences();
  CheckInRepository checkInRepository = CheckInRepository();

  late int? currentIndex = 0;
  List<Products>? products = [];
  List<String>? dataTable = [];

//response SO
  List<MapResponseSo>? mapResponseSO = [];
  MapResponseSo? responseSO = MapResponseSo();

  int? totalQuantity = 0;
  int? totalPriceProduct = 0;
  String? numberSO;
  // String? codeStore;
  // String? storeName;
  VisitData? visitData;
  String? storeName;
  String? storeCode;
  String? inDate;
  String? outDate;
  String? checkInImage;
  String? inTime;
  String? outTime;

  String? origin;
  String? destination;

  bool? isFromHome;

  void initCubit() async {
    await Future.delayed(Duration.zero);

    emit(CheckOutSalesLoading());

    await Future.delayed(const Duration(seconds: 1));

    visitData = data!['data'];

    log(const JsonEncoder.withIndent(' ').convert(visitData));
    isFromHome = data!['isFromHome'];

    if (isFromHome!) {
      changePage(index: 1);
    }

    if (currentIndex == 0) {
      // state form
      emit(CheckOutSalesCheckout());
      storeName = visitData!.storeName;
      storeCode = visitData!.storeCode;

      return;
    }

    if (currentIndex == 1) {
      // state history
      emit(CheckOutSalesInputSO());
      return;
    }

    // emit(CheckOutSalesLoaded());
  }

  void initCheckoutSalesCubit() async {
    await Future.delayed(Duration.zero);

    emit(CheckOutSalesLoading());

    visitData = data!['data'];

    inDate = visitData!.inDate != null
        ? generalHelper.convertDateToString(
            dateFormat: "EEEE, dd MMMM yyyy",
            dateTime: DateTime.parse(visitData!.inDate!),
          )
        : '-';
    outDate = visitData!.outDate != null
        ? generalHelper.convertDateToString(
            dateFormat: "EEEE, dd MMMM yyyy",
            dateTime: DateTime.parse(visitData!.outDate!),
          )
        : '-';

    log("visitData.inLat : ${visitData!.inLat}");
    log("visitData.inLong : ${visitData!.inLong}");
    if (visitData!.inLat != null && visitData!.inLong != null) {
      origin =
          await getAddressFromLatLng(
          double.parse(visitData!.inLat!), double.parse(visitData!.inLong!));
    }

    if (visitData!.outLat != null && visitData!.outLong != null) {
      destination =
          await getAddressFromLatLng(
          double.parse(visitData!.outLat!), double.parse(visitData!.outLong!));
    }

    List<String>? imageCheckin =
        List<String>.from(jsonDecode(visitData!.image!));
    // log("response : ${visitData!.image!}");
    // log("response : ${visitData!.image!.runtimeType}");
    checkInImage = imageCheckin[0];
    inTime = visitData!.inTime;
    outTime = visitData!.outTime;

    emit(CheckOutSalesLoaded());
  }

  void changePage({int? index}) async {
    visitData = data!['data'];

    currentIndex = index!;

    if (currentIndex == 0) {
      debugPrint("apakah e sini ?");
      // state form
      // initCheckoutSalesCubit();
      emit(CheckOutSalesLoading());

      visitData = data!['data'];

      inDate = visitData!.inDate != null
          ? generalHelper.convertDateToString(
              dateFormat: "EEEE, dd MMMM yyyy",
              dateTime: DateTime.parse(visitData!.inDate!),
            )
          : '-';
      outDate = visitData!.outDate != null
          ? generalHelper.convertDateToString(
              dateFormat: "EEEE, dd MMMM yyyy",
              dateTime: DateTime.parse(visitData!.outDate!),
            )
          : '-';

      log("visitData.inLat : ${visitData!.inLat}");
      log("visitData.inLong : ${visitData!.inLong}");
      if (visitData!.inLat != null && visitData!.inLong != null) {
        origin = await getAddressFromLatLng(
            double.parse(visitData!.inLat!), double.parse(visitData!.inLong!));
      }

      if (visitData!.outLat != null && visitData!.outLong != null) {
        destination = await getAddressFromLatLng(
            double.parse(visitData!.outLat!),
            double.parse(visitData!.outLong!));
      }

      List<String>? imageCheckin =
          List<String>.from(jsonDecode(visitData!.image!));
      // log("response : ${visitData!.image!}");
      // log("response : ${visitData!.image!.runtimeType}");
      checkInImage = imageCheckin[0];
      inTime = visitData!.inTime;
      outTime = visitData!.outTime;
      emit(CheckOutSalesCheckout());
      return;
    }

    if (currentIndex == 1) {
      // state history
      emit(InputSOLoading());
      log("start currentIndex");

      String userId = await preferences.read(PreferencesKey.userId);

      // log("visitData!.storeId, : ${visitData!.storeId}");

      var params = {
        "store_id": visitData!.storeId,
        "visit_id": visitData!.id,
        "user_id": userId,
      };
      final response = await ListProductGETApi().getStockData(params);
      if (response['data']['data'] != null ||
          response['data']['data'].isNotEmpty) {
        mapResponseSO = (response['data']['data'] as List<dynamic>)
            .map((e) => MapResponseSo.fromJson(e))
            .toList();
        if (mapResponseSO!.isNotEmpty) {
          responseSO = mapResponseSO!.last;
          dataTable = mapProductsToDataTable(responseSO!, dataTable);
        }
      } else {
        // Handle the case where data is null
        mapResponseSO = [];
      }

      emit(CheckOutSalesInputSO());
      return;
    }
  }

  void postCheckoutCubit() async {
    emit(CheckOutSalesLoading());

    Position position = await generalHelper.getCurrentPosition();

    String userLogin = await preferences.read(PreferencesKey.userLogin);
    String userId = await preferences.read(PreferencesKey.userId);
    String userName = await preferences.read(PreferencesKey.name);

    userLogin = userLogin.replaceAll('{', '').replaceAll('}', '');

    Map<String, dynamic> dataMap =
        Map.fromEntries(userLogin.split(',').map((entry) {
      final parts = entry.trim().split(':');
      final key = parts[0].trim();
      final value = parts[1].trim();
      return MapEntry(key, value);
    }));

    // Convert Map to UserLogin object
    // UserLogin users = UserLogin.fromJson(dataMap);
    UserLogin users = UserLogin(
      userId: userId,
      userName: userName,
      userType: 'sales',
    );

    DateTime currentServerTime = await generalHelper.getNtpTime();


    //Other toko store_id di isi null
    var params = {
      'store_id': visitData!.storeId.toString(),
      'store_name': visitData!.storeName,
      'store_code': visitData!.storeCode,
      'out_date': generalHelper.convertDateToString(
          dateTime: currentServerTime, dateFormat: "yyyy-MM-dd"),
      'out_time': generalHelper.convertDateToString(
          dateTime: currentServerTime, dateFormat: "HH:mm"),
      'out_lat': position.latitude.toString(),
      'out_long': position.longitude.toString(),
      'user_login': jsonEncode(users.toJson()),
      'user_id': userId,
      'method': 'patch',
    };

    final response = await checkInRepository
        .postSubmitData(params, 'out', visitData!.id!, []);

    if (response.status == Status.success) {
      emit(CheckOutSalesCheckoutSuccess());
      return;
    }

    if (response.status == Status.error) {
      emit(CheckOutSalesCheckoutFailed());
      return;
    }

    if (response.status == Status.failed) {
      emit(CheckOutSalesCheckoutFailed());
      return;
    }

    emit(CheckOutSalesLoaded());
  }

  Future<String?> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];

      String address =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";

      return address;
    } catch (e) {
      // Menangani error dan mengembalikan pesan error
      log("Error occurred: $e");
      return null; // Kamu juga bisa mengembalikan string error atau null sesuai kebutuhan
    }
  }

  void initInputSOPage() async {
    String userId = await preferences.read(PreferencesKey.userId);

    emit(InputSOLoading());

    // log("start initInputSOPage");

    visitData = data!['data'];

    // log("di sini kan ada store ID juga pada saat init : ${visitData!.storeId}");
    // log("visitData!.storeId, : ${visitData!.storeId}");

    var params = {
      "store_id": visitData!.storeId,
      "visit_id": visitData!.id,
      "user_id": userId,
    };
    final response = await ListProductGETApi().getStockData(params);
    if (response['data']['data'] != null ||
        response['data']['data'].isNotEmpty) {
      mapResponseSO = (response['data']['data'] as List<dynamic>)
          .map((e) => MapResponseSo.fromJson(e))
          .toList();
      if (mapResponseSO!.isNotEmpty) {
        responseSO = mapResponseSO!.last;
        dataTable = mapProductsToDataTable(responseSO!, dataTable);
        totalPriceProduct = responseSO!.totalPrice;
        totalQuantity = responseSO!.totalQty;
        numberSO = responseSO!.soCode;
      }
    }

    emit(InputSOLoaded());
  }

  void initListProduct() async {
    await Future.delayed(Duration.zero);
    emit(ListProductLoading());

    final response = await ListProductGETApi().fetchStocks();

    if (response['success'] == true) {
      products = (response['data']['data'] as List<dynamic>)
          .map((e) => Products.fromJson(e))
          .toList();
    }

    emit(ListProductLoaded());
  }

  void addProducts({
    String? namaBarang,
    String? jumlahBarang,
    String? hargaBarang,
  }) async {
    try {
      emit(InputAddingProductLoading());

      int? minPrice = 0;
      int? maxPrice = 0;
      int? totalPrice = 0;

      final response = await ListProductGETApi().fetchStocks();

      if (response['success'] == true) {
        products = (response['data']['data'] as List<dynamic>)
            .map((e) => Products.fromJson(e))
            .toList();
      }

      for (var item in products!) {
        if (item.name == namaBarang) {
          minPrice = item.minPrice;
          maxPrice = item.price;
        }
      }

      int price = int.parse(hargaBarang!);
      totalPrice = (int.parse(jumlahBarang!) * price);

      // log("data : $namaBarang");
      // log("data : $jumlahBarang");
      // log("data : $hargaBarang");
      // log("min : $minPrice");
      // log("max : $maxPrice");
      // log("price : $price");

      if (price >= minPrice! && price <= maxPrice!) {
        bool itemExists = dataTable!.any((item) {
          var parts = item.split(':');
          return parts[0] == namaBarang;
        });
        if (!itemExists) {
          dataTable!.add("$namaBarang:$jumlahBarang:$hargaBarang:$totalPrice");
        } else {
          emit(InputAddingProductAlreadyExist());
          return;
        }

        totalQuantity = 0;
        totalPriceProduct = 0;

        for (String item in dataTable!) {
          List<String> parts = item.split(':');

          int? number = int.parse(parts[1]);
          int? total = int.parse(parts[3]);
          totalQuantity = totalQuantity! + number;
          totalPriceProduct = totalPriceProduct! + total;
        }
        emit(InputAddingProductLoaded(
          datas: dataTable,
        ));
        return;
      } else {
        emit(InputAddingProductFailed());
        return;
      }
    } on Exception catch (e) {
      log("Error is :$e");
    }
  }

  void saveSOData() async {
    emit(SaveProductLoading());

    log("data tables : $dataTable");
    visitData = data!['data'];

    String userId = await preferences.read(PreferencesKey.userId);

    List<ProductEntity> productEntities = mapDataTableToProducts(dataTable!);

    // log("resppp : ${const JsonEncoder.withIndent(' ').convert(visitData)}");

    int? id = responseSO!.id ?? 0;

    MapProductEntity entity = MapProductEntity(
      refNo: null,
      products: productEntities,
      totalQty: totalQuantity,
      totalPrice: totalPriceProduct,
      storeId: visitData!.storeId.toString(),
      visitId: visitData!.id.toString(),
      userId: userId,
      stockId: id.toString(),
    );

    // log("productEntities : ${productEntities.length}");
    // log("stockId : ${responseSO!.id!.toString()}");

    if (responseSO!.id != null) {
      await ListProductGETApi().sendStockData(entity.toJson(), false);
    } else {
      await ListProductGETApi().sendStockData(entity.toJson(), true);
    }
    // log("resppp : ${const JsonEncoder.withIndent(' ').convert(entity)}");

    // log("response : $response");
    // log("response : $response");

    emit(SaveProductLoaded());
  }

  void removeItem(int? index) async {
    emit(RemoveProductLoading());

    if (dataTable!.isNotEmpty) {
      dataTable!.removeAt(index!);
    }

    totalQuantity = 0;
    totalPriceProduct = 0;

    for (String item in dataTable!) {
      List<String> parts = item.split(':');

      int? number = int.parse(parts[1]);
      int? total = int.parse(parts[3]);
      totalQuantity = totalQuantity! + number;
      totalPriceProduct = totalPriceProduct! + total;
    }

    emit(RemoveProductLoaded());
  }

  // Fungsi untuk memetakan dataTable ke products
  List<ProductEntity> mapDataTableToProducts(List<String> dataTable) {
    List<ProductEntity> products = [];
    int idCounter = 1; // Anda bisa menyesuaikan ID sesuai kebutuhan

    for (var item in dataTable) {
      var parts = item.split(':');
      String name = parts[0];
      int qty = int.parse(parts[1]);
      int price = int.parse(parts[2]);
      // int totalPrice = int.parse(parts[3]); // totalPrice tidak digunakan dalam ProductEntity

      ProductEntity product = ProductEntity(
        id: idCounter++, // Increment ID untuk setiap produk
        name: name,
        qty: qty,
        price: price,
      );

      products.add(product);
    }

    return products;
  }

  List<String>? mapProductsToDataTable(
      MapResponseSo mapResponseSo, List<String>? dataTable) {
    if (mapResponseSo.products != null) {
      for (var product in mapResponseSo.products!) {
        String namaBarang = product.name!;
        int jumlahBarang = product.qty!;
        int hargaBarang = product.price!;
        int totalPrice = jumlahBarang * hargaBarang;
        String formattedString =
            "$namaBarang:$jumlahBarang:$hargaBarang:$totalPrice";
        dataTable!.add(formattedString);
      }
    }
    return dataTable;
  }
}

class ListProductGETApi {
  Future<dynamic> fetchStocks() async {
    var request = http.Request(
        'GET', Uri.parse('https://visit.sanwin.my.id/api/products'));

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    Map<String, dynamic> responseMap = jsonDecode(responseBody);
    return responseMap;
  }

  Future<dynamic> getStockData(dynamic params) async {
    var request = http.Request(
        'GET',
        Uri.parse(
          'https://visit.sanwin.my.id/api/stocks?'
          'store_id=${params['store_id']}'
          '&visit_id=${params['visit_id']}'
          '&user_id=${params['user_id']}',
        ));

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    log("response message: $responseBody");
    Map<String, dynamic> responseMap = jsonDecode(responseBody);
    return responseMap;
  }

  Future<Map<String, dynamic>> sendStockData(
      dynamic bodyRequest, bool? isInitial) async {
    Uri? url;

    if (isInitial!) {
      url = Uri.parse('https://visit.sanwin.my.id/api/stocks');
    } else {
      url = Uri.parse(
          'https://visit.sanwin.my.id/api/stocks/${bodyRequest['stockId']}?_method=patch');
    }

    var headers = {
      'Content-Type': 'application/json',
    };

    var body = jsonEncode(bodyRequest);

    var request = http.Request('POST', url);
    request.headers.addAll(headers);
    request.body = body;

    http.StreamedResponse response = await request.send();
    log("response $response");
    String responseBody = await response.stream.bytesToString();
    Map<String, dynamic> responseMap = jsonDecode(responseBody);
    return responseMap;
  }
}
