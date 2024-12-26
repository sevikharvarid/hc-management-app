import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hc_management_app/domain/model/products.dart';
import 'package:hc_management_app/domain/model/so_response.dart';
import 'package:hc_management_app/domain/model/visits.dart';
import 'package:hc_management_app/features/order/cubit/order_only_state.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';
import 'package:http/http.dart' as http;

class OrderOnlySalesCubit extends Cubit<OrderOnlySalesState> {
  Map<String, dynamic>? data;

  OrderOnlySalesCubit(this.data) : super(InputSOInitial());

  MapResponseSo? responseSO = MapResponseSo();
  Preferences preferences = Preferences();
  List<MapResponseSo>? mapResponseSO = [];
  List<Products>? products = [];
  List<String>? dataTable = [];
  VisitData? visitData;

  String? numberSO;
  int? totalQuantity = 0;
  int? totalPriceProduct = 0;

  void initOrderOnly() async {
    String userId = await preferences.read(PreferencesKey.userId);

    emit(InputSOLoading());

    visitData = data!['data'];

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

  void saveSOData() async {
    emit(SaveProductLoading());

    log("data tables : $dataTable");
    visitData = data!['data'];

    String userId = await preferences.read(PreferencesKey.userId);

    List<ProductEntity> productEntities = mapDataTableToProducts(dataTable!);

    MapProductEntity entity = MapProductEntity(
      refNo: null,
      products: productEntities,
      totalQty: totalQuantity,
      totalPrice: totalPriceProduct,
      storeId: visitData!.storeId.toString(),
      visitId: visitData!.id.toString(),
      userId: userId,
      stockId: responseSO!.id!.toString(),
    );

    await ListProductGETApi().sendStockData(entity.toJson());

    emit(SaveProductLoaded());
  }

  List<String>? mapProductsToDataTable(
      MapResponseSo mapResponseSo, List<String>? dataTable) {
    if (mapResponseSo.products != null) {
      for (var product in mapResponseSo.products!) {
        log("sssssadgadgadg");
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

  // Fungsi untuk memetakan dataTable ke products
  List<ProductEntity> mapDataTableToProducts(List<String> dataTable) {
    List<ProductEntity> products = [];
    int idCounter = 1;

    for (var item in dataTable) {
      var parts = item.split(':');
      String name = parts[0];
      int qty = int.parse(parts[1]);
      int price = int.parse(parts[2]);

      ProductEntity product = ProductEntity(
        id: idCounter++,
        name: name,
        qty: qty,
        price: price,
      );

      products.add(product);
    }

    return products;
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
        Uri.parse('https://visit.sanwin.my.id/api/stocks?'
            'store_id=${params['store_id']}'
            // '&visit_id=${params['visit_id']}'
            // '&user_id=${params['user_id']}',
            ));

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    log("error message: $responseBody");
    Map<String, dynamic> responseMap = jsonDecode(responseBody);
    return responseMap;
  }

  Future<Map<String, dynamic>> sendStockData(dynamic bodyRequest) async {
    var url = Uri.parse('https://visit.sanwin.my.id/api/stocks');
    var headers = {
      'Content-Type': 'application/json',
      // 'Content-Type': 'application/x-www-form-urlencoded',
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
