import 'dart:developer';

import 'package:hc_management_app/domain/service/http_provider.dart';

class CheckInProvider {
  late HttpProvider apiProvider;
  late final String baseUrl = "http://103.140.34.220:280";

  Future<Map<String, dynamic>?> getStoreData(dynamic params) async {
    try {
      // String paramsUrl = "/api/stores";
      // String paramsUrl = "/api/stores?user_id=&search=";
      //Fix
      String paramsUrl = "/api/stores?user_id=$params&search=";
      // String paramsUrl = "/api/membersales?store_id=&limit=&user_id=$params";

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


  Future<Map<String, dynamic>?> postSubmitVisit(dynamic params) async {
    try {
      String paramsUrl = "/api/visits";

      apiProvider = HttpProvider(
        baseUrl: baseUrl,
        params: paramsUrl,
      );

      return await apiProvider.postWithVisitsImage(
        body: params,
      );
    } on Exception catch (e) {
      log("Error message : $e");
      throw Error();
    }
  }

}
