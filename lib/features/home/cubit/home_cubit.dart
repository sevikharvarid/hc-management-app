import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hc_management_app/config/service/background_service_init.dart';
import 'package:hc_management_app/domain/model/stores.dart';
import 'package:hc_management_app/domain/model/visits.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/features/check_in/repository/check_in_repository.dart';
import 'package:hc_management_app/features/home/repository/home_sales_repository.dart';
import 'package:hc_management_app/shared/utils/constant/app_constant.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/utils/helpers/month_pickers.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  String? name;
  String? photoProfile = '';
  List<VisitData> visits = [];

  // For store list in home page
  List<DataStoreSales> listToko = [];
  bool isChecked = false;
  bool isReadOnlyStore = false;
  DataStoreSales? dataStore;

  Preferences preferences = Preferences();
  GeneralHelper generalHelper = GeneralHelper();
  HomeSalesRepository homeSalesRepository = HomeSalesRepository();
  CheckInRepository checkInRepository = CheckInRepository();

  late BuildContext mContext = AppConstant.navigatorKey.currentContext!;

  void initCubit() async {
    await Future.delayed(Duration.zero);
    emit(HomeLoading());

    getLocations();

    await Future.delayed(const Duration(seconds: 1));

    BackgroundService().init();

    await Future.delayed(const Duration(seconds: 1));

    name = await preferences.read(PreferencesKey.name);

    photoProfile = await preferences.read(PreferencesKey.profilePhoto);

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

    String userId = await preferences.read(PreferencesKey.userId);

    log("User ID : $userId");

    var params = {
      "page": 1,
      "date_start":
          generalHelper.getMonthStartAndEndDate(initialMonth(mContext)!).first,
      "date_end":
          generalHelper.getMonthStartAndEndDate(initialMonth(mContext)!).last,
      "user_id": userId,
    };

    var response = await homeSalesRepository.getHistoryVisits(params);

    log("VISIT DATA : $response");

    if (response.status == Status.success) {
      visits = ((response.data['data']) as List<dynamic>)
          .map(
            (json) => VisitData.fromJson(json),
          )
          .toList();

      log("VISIT DATA : $visits");

      emit(HomeSuccessGet());
    }

    emit(HomeLoaded());
  }

  Future<void> getLocations() async {
    String? userId = await preferences.read(PreferencesKey.userId);
    log("user id in HOME is : $userId");

    var url =
        Uri.parse('https://visit.sanwin.my.id/api/intervals?user_id=$userId');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        // Mengakses nilai dalam objek Map
        var success = jsonResponse['success'];
        var message = jsonResponse['message'];
        var data = jsonResponse['data'];

        if (success) {
          log('Success: $message');
          // Lakukan sesuatu dengan data di sini
          log('Data: ${data['data'][0]['interval']}');
          log('Data: ${data['data'][0]['interval'].runtimeType}');
          await preferences.store(
              PreferencesKey.interval, data['data'][0]['interval'].toString());
        } else {
          log('Request failed with message: $message');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Request failed with error: $e');
    }
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
    emit(HomeLoading());
    Location location = Location();
    bool isOn = await location.serviceEnabled();

    if (!isOn) {
      bool isTurnedOn = await location.requestService();
      if (isTurnedOn) {
        emit(HomeNavigateLoaded());
        return true;
      } else {
        emit(HomeNavigateLoaded());

        return false;
      }
    } else {
      emit(HomeNavigateLoaded());

      return true;
    }
  }

  Future<bool> checkAndTurnOnGPSForOrderOnly() async {
    emit(HomeLoading());
    Location location = Location();
    bool isOn = await location.serviceEnabled();

    if (!isOn) {
      bool isTurnedOn = await location.requestService();
      if (isTurnedOn) {
        emit(HomeNavigateOrderLoaded());
        return true;
      } else {
        emit(HomeNavigateOrderLoaded());

        return false;
      }
    } else {
      emit(HomeNavigateOrderLoaded());

      return true;
    }
  }

  FutureOr<void> getStoreData() async {
    emit(HomeStoreFilterLoading());

    var userId = await preferences.read(PreferencesKey.userId);

    var params = userId;

    final response = await checkInRepository.getStoreData(params);

    final List<dynamic> responseData = response.data['data'];

    listToko =
        responseData.map((item) => DataStoreSales.fromJson(item)).toList();

    emit(HomeStoreFilterLoaded());
  }

  void setCheckBox(bool? value) async {
    isChecked = value!;

    if (isChecked) {
      isReadOnlyStore = true;
    } else {
      isReadOnlyStore = false;
    }
    emit(HomeStoreChecklistStore(
      state: isChecked,
    ));
  }
}
