import 'dart:developer';

import 'package:hc_management_app/domain/service/http_provider.dart';

class OrderOnlyProvider {

  late HttpProvider apiProvider;
  late final String baseUrl = "https://visit.sanwin.my.id";
  
  Future<Map<String, dynamic>?> postSubmitVisitOrder(
    dynamic params,
  ) async {
    try {
      String paramsUrl = "/api/visits/orderonly";

      apiProvider = HttpProvider(
        baseUrl: baseUrl,
        params: paramsUrl,
      );

      return await apiProvider.postOrderOnly(
        body: params,
      );
    } on Exception catch (e) {
      log("Error message : $e");
      throw Error();
    }
  }
}
