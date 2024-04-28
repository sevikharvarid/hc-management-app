import 'dart:developer';

import 'package:hc_management_app/domain/provider/home_spg_provider.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/domain/service/throw_exception.dart';
import 'package:hc_management_app/shared/utils/helpers/connectivity_helper.dart';

class HomeSpgRepository {
  ConnectivityHelper connectivityHelper = ConnectivityHelper();
  HomeSpgProvider homeSpgProvider = HomeSpgProvider();

  Future<DataResponse<String>> getStores(dynamic params) async {
    try {
      if (!await connectivityHelper.checkConnectivityStatus()) {
        return const DataResponse.noConnection();
      }

      var response = await homeSpgProvider.getStores(params);

      if (response!["responseCode"] == 200) {
        return DataResponse.success(data: response["data"]["data"]);
      } else {
        return DataResponse.error(message: response['message'].toString());
      }
    } on RequestTimeoutException {
      return const DataResponse.requestTimeOut();
    }
  }

  Future<DataResponse<String>> getRadiusStoreLocation(dynamic params) async {
    try {
      if (!await connectivityHelper.checkConnectivityStatus()) {
        return const DataResponse.noConnection();
      }

      var response = await homeSpgProvider.getRadiusStoreLocation(params);

      if (response!["responseCode"] == 200) {
        return DataResponse.success(data: response["data"]["data"]);
      } else {
        return DataResponse.error(message: response['message'].toString());
      }
    } on RequestTimeoutException {
      return const DataResponse.requestTimeOut();
    }
  }

  Future<DataResponse<String>> getListSPGName(dynamic params) async {
    try {
      if (!await connectivityHelper.checkConnectivityStatus()) {
        return const DataResponse.noConnection();
      }

      var response = await homeSpgProvider.getSPGName(params);

      if (response!["responseCode"] == 200) {
        return DataResponse.success(data: response["data"]["data"]);
      } else {
        return DataResponse.error(message: response['message'].toString());
      }
    } on RequestTimeoutException {
      return const DataResponse.requestTimeOut();
    }
  }

  Future<DataResponse<String>> postSubmitData(dynamic body) async {
    try {
      if (!await connectivityHelper.checkConnectivityStatus()) {
        return const DataResponse.noConnection();
      }

      var response = await homeSpgProvider.postSubmitData(body);

      log("response nya : $response");

      if (response!["responseCode"] == 201) {
        return DataResponse.success(data: response['data']);
      } else {
        return DataResponse.error(message: response['message']);
      }
    } on RequestTimeoutException {
      return const DataResponse.requestTimeOut();
    }
  }
}
