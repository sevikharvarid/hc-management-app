import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hc_management_app/domain/model/list_spg.dart';
import 'package:hc_management_app/domain/model/stores.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/features/homespg/repository/home_spg_repository.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';
import 'package:location/location.dart';

part 'home_spg_state.dart';

class HomeSpgCubit extends Cubit<HomeSpgState> {
  HomeSpgCubit() : super(HomeSpgInitial());

  String? imagePath;
  String? namaToko = "";
  String? nameSPG;
  List<DataSpg> listSPG = [];
  DataSpg? dataSPG;

  String? latitudeStore;
  String? longitudeStore;

  String? radiusStore;
  double? radiusUser;


  String? photoProfile;

  List<DataStore> dataStores = [];

  Preferences preferences = Preferences();

  HomeSpgRepository homeSpgRepository = HomeSpgRepository();
  GeneralHelper generalHelper = GeneralHelper();

  late bool isLocationEnabled = false;
  late bool isConnected = true;
  late bool isChanges = false;

  void initCubit() async {
    nameSPG = await preferences.read(PreferencesKey.name);

    emit(HomeSpgLoading());

    // Inisialisasi layanan latar belakang jika izin diberikan
    // if (await Permission.location.isGranted) {
    //   await BackgroundService.instance.init();
    // }
    photoProfile = await preferences.read(PreferencesKey.profilePhoto);

    var params = await preferences.read(PreferencesKey.userId);

    final response = await homeSpgRepository.getStores(params);

    if (response.status == Status.success) {
      dataStores = (response.data['data'] as List)
          .map((e) => DataStore.fromJson(e))
          .toList();
      if (dataStores.isNotEmpty) {
        namaToko = dataStores[0].name;
      } else {
        namaToko = "Toko belum di assign di user ini";
      }
      emit(HomeSpgSuccessLoaded());
      return;
    }

    if (response.status == Status.error) {
      emit(const HomeSpgFailed());
      return;
    }

    emit(HomeSpgLoaded());
  }

  

  Future<void> checkRadiusStore() async {
    emit(HomeSpgLoading());

    var storeId = await preferences.read(PreferencesKey.storeId);

    log("store ID : $storeId");

    var paramsRadius = storeId;
    final response =
        await homeSpgRepository.getRadiusStoreLocation(paramsRadius);

    log("Respinse : $response");

    latitudeStore = response.data['data'][0]["latt"];
    longitudeStore = response.data['data'][0]["long"];
    radiusStore = response.data['data'][0]["radius"].toString();

    double radius = await generalHelper.getPositionRadius(
      double.tryParse(latitudeStore!),
      double.tryParse(longitudeStore!),
    );

    radiusUser = radius;

    log(" radius : $radiusUser");

    emit(HomeSpgLoaded());
  }

  void checkGPS() async {
    Location location = Location();
    bool ison = await location.serviceEnabled();

    if (!ison) {
      //if defvice is off
      bool isturnedon = await location.requestService();
      if (isturnedon) {
      } else {
        checkGPS();
      }
    }
  }

  Future<bool> checkAndTurnOnGPS() async {
    Location location = Location();
    bool isOn = await location.serviceEnabled();

    if (!isOn) {
      bool isTurnedOn = await location.requestService();
      if (isTurnedOn) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }


  void saveImage({String? image}) {
    emit(HomeSpgLoading());

    imagePath = image;

    emit(
      HomeSpgImageSaved(
        imagePath: imagePath,
      ),
    );
  }

  void getListSPGName() async {
    emit(HomeSpgFilterLoading());

    var userId = await preferences.read(PreferencesKey.userId);

    var params = userId;

    final response = await homeSpgRepository.getListSPGName(params);
    log("reso : ${response.data}");
    final List<dynamic> responseData = response.data['data'];

    listSPG = responseData.map((item) => DataSpg.fromJson(item)).toList();

    emit(HomeSpgFilterLoaded());
  }

  void postInCubit({String? category}) async {
    emit(HomeSpgLoading());

    Position position = await generalHelper.getCurrentPosition();

    String userLogin = await preferences.read(PreferencesKey.userLogin);

    userLogin = userLogin.replaceAll('{', '').replaceAll('}', '');

    Map<String, dynamic> dataMap =
        Map.fromEntries(userLogin.split(',').map((entry) {
      final parts = entry.trim().split(':');
      final key = parts[0].trim();
      final value = parts[1].trim();
      return MapEntry(key, value);
    }));

    String jsonString = jsonEncode(dataMap);

    var params = {
      'spg_name': dataSPG!.userName.toString(),
      'spg_id': dataSPG!.userId.toString(),
      'store_id': dataStores[0].id.toString(),
      'store_name': dataStores[0].name,
      'date': generalHelper.convertDateToString(
          dateTime: DateTime.now(), dateFormat: "yyyy-MM-dd"),
      'time': generalHelper.convertDateToString(
          dateTime: DateTime.now(), dateFormat: "HH:mm"),
      'type': category,
      'latt': position.latitude.toString(),
      'long': position.longitude.toString(),
      'user_login': jsonString,
      'image': imagePath,
    };

    log("REQUEST : $params");

    final response = await homeSpgRepository.postSubmitData(params);

    log("response : ${response.data}");
    log("response : ${response.status}");

    if (response.status == Status.success) {
      emit(HomeSpgSuccess(message: response.data['message']));
      imagePath = null;
      return;
    }

    if (response.status == Status.failed) {
      emit(HomeSpgFailed(message: response.message));
      return;
    }

    if (response.status == Status.error) {
      emit(HomeSpgFailed(message: response.message));
      return;
    }


    emit(HomeSpgLoaded());
  }
}
