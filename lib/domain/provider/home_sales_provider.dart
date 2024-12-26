import 'dart:developer';

import 'package:hc_management_app/domain/service/http_provider.dart';

class HomeSalesProvider {
  late HttpProvider apiProvider;
  late final String baseUrl = "https://visit.sanwin.my.id";

  Future<Map<String, dynamic>?> getHistoryVisits(dynamic params) async {
    try {
      String paramsUrl =
          "/api/visits?store_type=&user_id=${params['user_id']}"
          "&date_start=${params['date_start']}"
          "&date_end=${params['date_end']}"
          "&search="
          "&page=${params['page']}";
    
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
