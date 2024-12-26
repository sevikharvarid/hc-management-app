import 'dart:developer';

import 'package:hc_management_app/domain/service/http_provider.dart';

class HistorySPGProvider {
  late HttpProvider apiProvider;
  late final String baseUrl = "https://visit.sanwin.my.id";

  Future<Map<String, dynamic>?> getHistoryAbsence(dynamic params) async {
    try {
      String paramsUrl = "/api/absents?store_id=${params['store_id']}"
          "&type=${params['type']}"
          "&date_start=${params['date_start']}"
          "&date_end=${params['date_end']}"
          "&search=${params['search']}";

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
