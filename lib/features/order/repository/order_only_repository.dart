import 'dart:developer';

import 'package:hc_management_app/domain/provider/check_in_provider.dart';
import 'package:hc_management_app/domain/provider/order_only_provider.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/domain/service/throw_exception.dart';
import 'package:hc_management_app/shared/utils/helpers/connectivity_helper.dart';

class OrderOnlyStoreRepository {
  ConnectivityHelper connectivityHelper = ConnectivityHelper();
  CheckInProvider checkInProvider = CheckInProvider();
  OrderOnlyProvider orderOnlyProvider = OrderOnlyProvider();

  Future<DataResponse<String>> getStoreData(dynamic params) async {
    try {
      if (!await connectivityHelper.checkConnectivityStatus()) {
        return const DataResponse.noConnection();
      }

      var response = await checkInProvider.getStoreData(params);

      if (response!["responseCode"] == 200) {
        return DataResponse.success(data: response["data"]["data"]);
      } else {
        return DataResponse.error(message: response['message'].toString());
      }
    } on RequestTimeoutException {
      return const DataResponse.requestTimeOut();
    }
  }

  Future<DataResponse<String>> postSubmitData(
    dynamic body,
  ) async {
    try {
      if (!await connectivityHelper.checkConnectivityStatus()) {
        return const DataResponse.noConnection();
      }

      var response = await orderOnlyProvider.postSubmitVisitOrder(
        body,
      );

      log("response in repository : $response");

      if (response!["responseCode"] == 200 || response["responseCode"] == 201) {
        return DataResponse.success(data: response['data']);
      } else {
        return DataResponse.error(message: response['message']);
      }
    } on RequestTimeoutException {
      return const DataResponse.requestTimeOut();
    }
  }
}
