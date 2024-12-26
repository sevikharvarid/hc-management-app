import 'dart:developer';

import 'package:hc_management_app/domain/service/http_provider.dart';

class HomeSpgProvider {
  late HttpProvider apiProvider;
  late final String baseUrl = "https://visit.sanwin.my.id";

  Future<Map<String, dynamic>?> getStores(dynamic params) async {
    try {
      String paramsUrl = "/api/stores?user_id=$params";

      apiProvider = HttpProvider(
        baseUrl: baseUrl,
        params: paramsUrl,
      );

      return await apiProvider.get();
    } on Exception catch (e) {
      log("Error message : $e");
      throw Error();
    }
  }

  Future<Map<String, dynamic>?> getSPGName(dynamic params) async {
    try {
      String paramsUrl =
          "/api/memberspvs?type=spg&isnotspv=1&spv_id=$params&limit=999";

      apiProvider = HttpProvider(
        baseUrl: baseUrl,
        params: paramsUrl,
      );

      return await apiProvider.get();
    } on Exception catch (e) {
      log("Error message : $e");
      throw Error();
    }
  }

  Future<Map<String, dynamic>?> postSubmitData(dynamic params) async {
    try {
      String paramsUrl = "/api/absents";

      apiProvider = HttpProvider(
        baseUrl: baseUrl,
        params: paramsUrl,
      );

      return await apiProvider.postWithAbsenceImage(
        body: params,
      );
    } on Exception catch (e) {
      log("Error message : $e");
      throw Error();
    }
  }


  Future<Map<String, dynamic>?> getRadiusStoreLocation(dynamic params) async {
    try {
      String paramsUrl = "/api/storelocations?limit=1&store_id=$params";

      apiProvider = HttpProvider(
        baseUrl: baseUrl,
        params: paramsUrl,
      );

      return await apiProvider.get();
    } on Exception catch (e) {
      log("Error message : $e");
      throw Error();
    }
  }
}
