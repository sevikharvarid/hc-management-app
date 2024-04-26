import 'dart:convert';
import 'dart:developer';

import 'package:hc_management_app/domain/service/http_provider.dart';

class LoginProvider {
  late HttpProvider apiProvider;
  late final String baseUrl = "http://103.140.34.220:280";

  Future<Map<String, dynamic>?> postLogin(dynamic body) async {
    try {
      String paramsUrl = "/api/users/login";

      apiProvider = HttpProvider(
        baseUrl: baseUrl,
        params: paramsUrl,
      );
      final String data = jsonEncode(body);
      return await apiProvider.post(body: data);
    } on Exception catch (e) {
      // navigateToLogout();
      log("Error message : $e");
      throw Error();
    }
  }
}
