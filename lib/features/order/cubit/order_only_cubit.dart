import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hc_management_app/config/service/background_service_init.dart';
import 'package:hc_management_app/domain/model/products.dart';
import 'package:hc_management_app/domain/model/so_response.dart';
import 'package:hc_management_app/domain/model/stores.dart';
import 'package:hc_management_app/domain/model/visits.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/features/order/repository/order_only_repository.dart';
import 'package:hc_management_app/features/profile/repository/profile_repository.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';
import 'package:http/http.dart' as http;

part 'order_only_state.dart';

class OrderOnlyStoreCubit extends Cubit<OrderOnlyStoreState> {
  Map<String, dynamic>? data;

  OrderOnlyStoreCubit(this.data) : super(OrderOnlyStoreInitial());

  OrderOnlyStoreRepository orderOnlyStoreRepository =
      OrderOnlyStoreRepository();
  ProfileRepository profileRepository = ProfileRepository();

  GeneralHelper helpers = GeneralHelper();

  bool isChecked = false;
  bool isReadOnlyStore = false;

  List<DataStoreSales> listToko = [];
  DataStoreSales? dataStore;

  Position? userPosition;

  File? imagePath;
  late int? totalImage = 1;

  List<File>? fileImages = [];

  // For Input SO Number
  VisitData? visitData;
  List<MapResponseSo>? mapResponseSO = [];
  MapResponseSo? responseSO = MapResponseSo();
  int? totalPriceProduct = 0;
  List<String>? dataTable = [];
  int? totalQuantity = 0;
  String? numberSO;
  List<Products>? products = [];


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


  void initCubit() async {
    var params = await preferences.read(PreferencesKey.userId);

    emit(OrderOnlyStoreLoading());

    userPosition = await helpers.getCurrentPosition();
    var response = await profileRepository.getProfile(params);

    await getStoreData();

    totalImage = response.data['total_image'];
    log("response : $totalImage");

    emit(OrderOnlyStoreLoaded());
  }

  void postData({
    String? storeCode,
    String? storeName,
    String? notes,
  }) async {
    emit(OrderOnlyStoreLoading());

    // Position position = await generalHelper.getCurrentPosition();

    String userId = await preferences.read(PreferencesKey.userId);
    String userName = await preferences.read(PreferencesKey.name);

    String userLogin = await preferences.read(PreferencesKey.userLogin);
    userLogin = userLogin.replaceAll('{', '').replaceAll('}', '');

    // Convert Map to UserLogin object
    // UserLogin users = UserLogin.fromJson(dataMap);
    UserLogin users = UserLogin(
      userId: userId,
      userName: userName,
      userType: 'sales',
    );

    int storeId = 0;

    log("item storeeCode : $storeCode");
    log("item storeName : $storeName");

    for (var item in listToko) {
      log("item element : $item");
      if (item.storeCode == storeCode) {
        storeId = item.storeId;
      }
    }

    //Other toko store_id di isi null
    //store_code 'other'
    String? idStore;
    String? codeStore;

    if (storeCode == null || storeCode.isEmpty) {
      idStore = '0';
      codeStore = 'other';
      log("masuk ke sini ?");
    } else {
      log("atau masuk ke sini ?");

      idStore = storeId.toString();
      codeStore = storeCode;
    }

    var params = {
      'store_id': idStore,
      'store_name': storeName,
      'store_code': codeStore,
      'user_login': jsonEncode(users.toJson()),
      'user_id': userId,
    };

    final response = await orderOnlyStoreRepository.postSubmitData(
      params,
    );
    log("response is : $response");

    visitData = VisitData.fromJson(response.data['data']);

    if (response.status == Status.success) {
      emit(OrderOnlyStoreSuccess(data: visitData));
      return;
    }

    if (response.status == Status.error) {
      emit(const OrderOnlyStoreFailed());
      return;
    }

    emit(OrderOnlyStoreLoaded());
  }

  void saveImage(List<File>? files) {
    // Inisialisasi atau reset fileImages menjadi daftar kosong setiap kali fungsi dipanggil
    fileImages = [];

    if (files != null && files.isNotEmpty) {
      for (var i in files) {
        fileImages!.add(i);
      }
    }

    log("images : $fileImages");

    emit(OrderOnlyStoreSpgImageSaved(
      imagePath: fileImages,
    ));
  }

  void setCheckBox(bool? value) async {
    isChecked = value!;

    if (isChecked) {
      isReadOnlyStore = true;
    } else {
      isReadOnlyStore = false;
    }
    emit(OrderOnlyStoreChecklistStore(
      state: isChecked,
    ));
  }

  void setIsReadOnlyStoreField(bool? value) async {
    isReadOnlyStore = value!;
    emit(OrderOnlyStoreChecklistStoreIsReadOnly(
      state: isReadOnlyStore,
    ));
  }

  FutureOr<void> getStoreData() async {
    emit(OrderOnlyStoreFilterLoading());

    var userId = await preferences.read(PreferencesKey.userId);

    var params = userId;

    final response = await orderOnlyStoreRepository.getStoreData(params);

    final List<dynamic> responseData = response.data['data'];

    listToko =
        responseData.map((item) => DataStoreSales.fromJson(item)).toList();

    emit(OrderOnlyStoreFilterLoaded());
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

class OrderOnlyStoreService {
  Future<dynamic> sendVisitData({
    dynamic body,
    List<String>? imagePath,
  }) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://visit.sanwin.my.id/api/visits'));

    request.fields.addAll({
      'store_id': body['store_id'],
      'store_name': body['store_name'],
      'store_code': body['store_code'],
      'note': body['note'],
      'in_date': body['in_date'],
      'in_time': body['in_time'],
      'in_lat': body['in_lat'],
      'in_long': body['in_long'],
      'user_login': body['user_login'],
      'user_id': body['user_id'],
    });

    for (var image in imagePath!) {
      request.files.add(await http.MultipartFile.fromPath('image[]', image));
    }

    http.StreamedResponse response = await request.send();
    log("response is : ${await response.stream.bytesToString()}");
    String responseBody = await response.stream.bytesToString();
    Map<String, dynamic> responseMap = jsonDecode(responseBody);
    return responseMap;
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
