import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hc_management_app/config/service/background_service_init.dart';
import 'package:hc_management_app/domain/model/stores.dart';
import 'package:hc_management_app/domain/model/visits.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/features/check_in/repository/check_in_repository.dart';
import 'package:hc_management_app/features/profile/repository/profile_repository.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';
import 'package:http/http.dart' as http;

part 'check_in_state.dart';

class CheckInCubit extends Cubit<CheckInState> {
  CheckInCubit() : super(CheckInInitial());

  CheckInRepository checkInRepository = CheckInRepository();
  ProfileRepository profileRepository = ProfileRepository();

  GeneralHelper helpers = GeneralHelper();

  bool isChecked = false;
  bool isReadOnlyStore = false;

  List<DataStoreSales> listToko = [];
  List<DataStoreSales> listTokoTemporary = [];
  DataStoreSales? dataStore;

  Position? userPosition;

  File? imagePath;
  late int? totalImage = 1;

  List<File>? fileImages = [];

  late String? userName = '';
  late String? storeName = '';
  late String? notes = '';
  late String? userAddress = '';

  void initCubit() async {
    var params = await preferences.read(PreferencesKey.userId);

    emit(CheckInLoading());

    userPosition = await helpers.getCurrentPosition();
    var response = await profileRepository.getProfile(params);

    await getStoreData();

    // Ambil lokasi pengguna
    String userAddress = await getCurrentAddress();

    log("storeName : $storeName");

    totalImage = response.data['total_image'];

    userName = response.data['name'];
    notes = response.data['notes'];
    userAddress = userAddress;
    log("response : $totalImage");

    emit(CheckInLoaded());
  }

  void postData({
    String? storeCode,
    String? storeName,
    String? notes,
  }) async {
    emit(CheckInLoading());

    Position? position = await generalHelper.getCurrentPosition();

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

    List<String> images = [];

    for (var item in fileImages!) {
      images.add(item.path);
    }

    DateTime currentServerTime = await generalHelper.getNtpTime();

    var params = {
      'store_id': idStore,
      'store_name': storeName,
      'store_code': codeStore,
      'note': notes,
      'in_date': generalHelper.convertDateToString(
          dateTime: currentServerTime, dateFormat: "yyyy-MM-dd"),
      'in_time': generalHelper.convertDateToString(
          dateTime: currentServerTime, dateFormat: "HH:mm"),
      'in_lat': position.latitude.toString(),
      'in_long': position.longitude.toString(),
      'user_login': jsonEncode(users.toJson()),
      'user_id': userId,
    };

    final response =
        await checkInRepository.postSubmitData(params, 'in', null, images);
    log("response is : $response");

    if (response.status == Status.success) {
      emit(CheckInSuccess());
      return;
    }

    if (response.status == Status.error) {
      emit(const CheckInFailed());
      return;
    }

    emit(CheckInLoaded());
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

    emit(CheckInSpgImageSaved(
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
    emit(CheckInChecklistStore(
      state: isChecked,
    ));
  }

  void setIsReadOnlyStoreField(bool? value) async {
    isReadOnlyStore = value!;
    emit(CheckInChecklistStoreIsReadOnly(
      state: isReadOnlyStore,
    ));
  }

  FutureOr<void> getStoreData() async {
    emit(CheckInFilterLoading());

    var userId = await preferences.read(PreferencesKey.userId);

    // var params = userId;
    var params = {
      'userId': userId,
      'search': '',
    };

    final response = await checkInRepository.getStoreData(params);

    final List<dynamic> responseData = response.data['data'];

    listToko =
        responseData.map((item) => DataStoreSales.fromJson(item)).toList();
    listTokoTemporary = listToko;

    emit(CheckInFilterLoaded());
  }

  FutureOr<void> filterLocation({String? value}) async {
    emit(CheckInFilterLoading());

    if (value == null || value.isEmpty || value.length < 3) {
      listToko = listTokoTemporary;
      emit(CheckInFilterLoaded());
      return;
    }

    // Jika pencarian lebih dari 3 karakter, panggil API
    var userId = await preferences.read(PreferencesKey.userId);

    var params = {
      'userId': userId,
      'search': value,
    };

    try {
      final response = await checkInRepository.getStoreData(params);
      final List<dynamic> responseData = response.data['data'];

      listToko =
          responseData.map((item) => DataStoreSales.fromJson(item)).toList();
    } catch (e) {
      debugPrint("Error fetching store data: $e");
      listToko = [];
    }

    emit(CheckInFilterLoaded());
  }

  // Fungsi mendapatkan alamat real-time
  Future<String> getCurrentAddress() async {
    try {
      // Pastikan izin lokasi diberikan
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return "Lokasi tidak aktif";
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          return "Izin lokasi ditolak";
        }
        if (permission == LocationPermission.denied) {
          return "Izin lokasi belum diberikan";
        }
      }

      // Ambil koordinat saat ini
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Konversi koordinat ke alamat
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
      } else {
        return "Alamat tidak ditemukan";
      }
    } catch (e) {
      return "Gagal mendapatkan alamat";
    }
  }
}

class CheckInService {
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
