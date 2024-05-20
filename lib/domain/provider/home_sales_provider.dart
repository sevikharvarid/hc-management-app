import 'dart:developer';

import 'package:hc_management_app/domain/service/http_provider.dart';

class HomeSalesProvider {
  late HttpProvider apiProvider;
  late final String baseUrl = "http://103.140.34.220:280";

  Future<Map<String, dynamic>?> getHistoryVisits(dynamic params) async {
    try {
      String paramsUrl =
          "/api/visits?store_id=&store_type=&date_start=&date_end=&search=&page=1";

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
