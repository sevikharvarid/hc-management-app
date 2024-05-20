import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hc_management_app/config/service/background_service_init.dart';
import 'package:hc_management_app/domain/model/stores.dart';
import 'package:hc_management_app/features/check_in/repository/check_in_repository.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';

part 'check_in_state.dart';

class CheckInCubit extends Cubit<CheckInState> {
  CheckInCubit() : super(CheckInInitial());

  CheckInRepository checkInRepository = CheckInRepository();
  GeneralHelper helpers = GeneralHelper();

  bool isChecked = false;
  bool isReadOnlyStore = false;

  List<DataStore> listToko = [];
  DataStore? dataStore;

  Position? userPosition;

  File? imagePath;

  void initCubit() async {
    emit(CheckInLoading());

    userPosition = await helpers.getCurrentPosition();

    emit(CheckInLoaded());
  }

  void postData({
    String? storeCode,
    String? storeName,
    String? notes,
  }) async {
    emit(CheckInLoading());

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
    int storeId = 0;

    for (var item in listToko) {
      if (item.code == storeCode) {
        storeId = item.id;
      }
    }

    //Other toko store_id di isi null
    //store_code 'other'
    var params = {
      'store_id': storeId.toString(),
      'store_name': storeName,
      'store_type': 'type', //Tidak perlu
      //store_code : 'other'
      'note': notes,
      'in_date': generalHelper.convertDateToString(
          dateTime: DateTime.now(), dateFormat: "yyyy-MM-dd"),
      'in_time': generalHelper.convertDateToString(
          dateTime: DateTime.now(), dateFormat: "HH:mm"),
      'in_lat': position.latitude.toString(),
      'in_long': position.longitude.toString(),
      // 'out_date': generalHelper.convertDateToString(
      //     dateTime: DateTime.now(), dateFormat: "yyyy-MM-dd"),
      // 'out_time': generalHelper.convertDateToString(
      //     dateTime: DateTime.now(), dateFormat: "HH:mm"),
      // 'out_lat': position.latitude.toString(),
      // 'out_long': position.longitude.toString(),
      'user_login': jsonString,
      'image': imagePath!.path,
    };

    final response = await checkInRepository.postSubmitData(params);
    log("response is : $response");

    emit(CheckInLoaded());
  }


  void saveImage(List<File>? imageValue) {
    if (imageValue!.isNotEmpty) {
      imagePath = imageValue.first;
    } else {
      imagePath = null;
    }

    emit(CheckInSpgImageSaved(
      imagePath: imagePath,
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

  void getStoreData() async {
    emit(CheckInFilterLoading());

    var userId = await preferences.read(PreferencesKey.userId);

    var params = userId;
    
    final response = await checkInRepository.getStoreData(params);
    final List<dynamic> responseData = response.data['data'];

    listToko =
        responseData.map((item) => DataStore.fromJson(item)).toList();

    emit(CheckInFilterLoaded());
  }
}
