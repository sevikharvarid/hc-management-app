import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hc_management_app/domain/model/visits.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/features/home/repository/home_sales_repository.dart';
import 'package:hc_management_app/shared/utils/constant/app_constant.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/utils/helpers/month_pickers.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';
import 'package:location/location.dart';

part 'request_sales_state.dart';

class RequestSalesCubit extends Cubit<RequestSalesState> {
  RequestSalesCubit() : super(RequestSalesInitial());

  GeneralHelper generalHelper = GeneralHelper();
  Preferences preferences = Preferences();
  HomeSalesRepository homeSalesRepository = HomeSalesRepository();

  late BuildContext mContext = AppConstant.navigatorKey.currentContext!;

  List<VisitData> visits = [];

  void initCubit() async {
    String userLogin = await preferences.read(PreferencesKey.userLogin);

    emit(RequestSalesLoading());

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

    var params = {
      "page": 1,
      "date_start":
          generalHelper.getMonthStartAndEndDate(initialMonth(mContext)!).first,
      "date_end":
          generalHelper.getMonthStartAndEndDate(initialMonth(mContext)!).last,
      "user_id": userId,
    };

    var response = await homeSalesRepository.getHistoryVisits(params);

    if (response.status == Status.success) {
      visits = ((response.data['data']) as List<dynamic>)
          .map(
            (json) => VisitData.fromJson(json),
          )
          .toList();
      emit(RequestSalesSuccessGet());
    }
    emit(RequestSalesLoaded());
  }

  void selectMonth({String? month}) async {
    emit(RequestSalesLoading());

    String userId = await preferences.read(PreferencesKey.userId);

    var params = {
      "page": 1,
      "date_start": generalHelper.getMonthStartAndEndDate(month!).first,
      "date_end": generalHelper.getMonthStartAndEndDate(month).last,
      "user_id": userId,
    };

    var response = await homeSalesRepository.getHistoryVisits(params);

    if (response.status == Status.success) {
      visits = ((response.data['data']) as List<dynamic>)
          .map(
            (json) => VisitData.fromJson(json),
          )
          .toList();
      emit(RequestSalesSuccessGet());
    }

    emit(RequestSalesLoaded());
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
}
