import 'dart:developer';

import 'package:hc_management_app/domain/service/http_provider.dart';

class HomeSpgProvider {
  late HttpProvider apiProvider;
  late final String baseUrl = "http://103.140.34.220:280";

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
      String paramsUrl = "/api/users?type=spg&isnotspv=1";

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

      // final String data = jsonEncode(params);
      return await apiProvider.postWithAbsenceImage(
        body: params,
      );
    } on Exception catch (e) {
      log("Error message : $e");
      throw Error();
    }
  }

  // Future<Map<String, dynamic>?> postSubmitData(dynamic params) async {
  //   try {
  //     String paramsUrl = "/api/absents";
  //     String stringUrl = "$baseUrl$paramsUrl";

  //     var request = http.MultipartRequest('POST', Uri.parse(stringUrl));
  //     request.fields.addAll({
  //       'store_id': params['store_id'],
  //       'store_name': params['store_name'],
  //       'date': params['date'],
  //       'time': params['time'],
  //       'type': params['type'],
  //       'latt': params['latt'],
  //       'long': params['long'],
  //       'user_login': params['user_login'],
  //     });

  //     request.files
  //         .add(await http.MultipartFile.fromPath('image', params['image']));

  //     http.StreamedResponse response = await request.send();

  //     // Konversi respons menjadi string JSON
  //     String responseBody = await response.stream.bytesToString();

  //     // Print respons untuk debug
  //     print("RESPONSE: $responseBody");

  //     // Konversi string JSON menjadi Map
  //     Map<String, dynamic>? jsonResponse = json.decode(responseBody);

  //     return jsonResponse;
  //   } on Exception catch (e) {
  //     log("Error message : $e");
  //     throw Error();
  //   }
  // }
}
