import 'dart:developer';

import 'package:hc_management_app/domain/service/http_provider.dart';

class CheckInProvider {
  late HttpProvider apiProvider;
  late final String baseUrl = "https://visit.sanwin.my.id";

  Future<Map<String, dynamic>?> getStoreData(dynamic params) async {
    try {
      // String paramsUrl = "/api/stores";
      // String paramsUrl = "/api/stores?user_id=&search=";
      //Fix
      // String paramsUrl = "/api/stores?user_id=$params?limit=&search";
      String paramsUrl = "/api/membersales?user_id=$params";

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

  Future<Map<String, dynamic>?> postSubmitVisit(
    dynamic params,
    String? status,
    int? id,
    List<String>? imagePaths,
  ) async {
    try {
      String paramsUrl = status == 'in' ? "/api/visits" : "/api/visits/$id";

      apiProvider = HttpProvider(
        baseUrl: baseUrl,
        params: paramsUrl,
      );

      return await apiProvider.postWithVisitsImage(
        body: params,
        status: status,
        imagePaths: imagePaths!,
      );
    } on Exception catch (e) {
      log("Error message : $e");
      throw Error();
    }
  }
}
