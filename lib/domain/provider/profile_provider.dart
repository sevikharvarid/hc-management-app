import 'dart:convert';
import 'dart:developer';

import 'package:hc_management_app/domain/service/http_provider.dart';

class ProfileProvider {
  late HttpProvider apiProvider;
  late final String baseUrl = "http://103.140.34.220:280";

  Future<Map<String, dynamic>?> getProfile(dynamic params) async {
    try {
      String paramsUrl = "/api/users/$params";

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

  Future<Map<String, dynamic>?> updateProfile(dynamic params) async {
    try {
      String paramsUrl = "/api/users/$params";

      apiProvider = HttpProvider(
        baseUrl: baseUrl,
        params: paramsUrl,
      );

      final String data = jsonEncode(params);
      return await apiProvider.post(body: data);
    } on Exception catch (e) {
      log("Error message : $e");
      throw Error();
    }
  }
}
