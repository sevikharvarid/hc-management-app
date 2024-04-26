import 'dart:convert';
import 'dart:developer';

import 'package:hc_management_app/domain/service/http_provider.dart';
import 'package:http/http.dart' as http;

class CheckInProvider {
  late HttpProvider apiProvider;
  late final String baseUrl = "http://103.140.34.220:280";

  Future<Map<String, dynamic>?> getStoreData(dynamic params) async {
    try {
      String paramsUrl = "/api/stores";

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
      String stringUrl = "$baseUrl$paramsUrl";

      var request = http.MultipartRequest('POST', Uri.parse(stringUrl));
      request.fields.addAll({
        'store_id': params['store_id'],
        'store_name': params['store_name'],
        'date': params['date'],
        'time': params['time'],
        'type': params['type'],
        'latt': params['latt'],
        'long': params['long'],
        'user_login': params['user_login'],
      });

      request.files
          .add(await http.MultipartFile.fromPath('image', params['image']));

      http.StreamedResponse response = await request.send();

      log("data nya ini sih : ${json.decode(await response.stream.bytesToString())}");

      return json.decode(await response.stream.bytesToString());
    } on Exception catch (e) {
      log("Error message : $e");
      throw Error();
    }
  }
}
