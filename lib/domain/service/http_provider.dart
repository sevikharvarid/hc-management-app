import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:hc_management_app/shared/utils/constant/app_constant.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class HttpProvider {
  final String? baseUrl;
  final String? params;

  HttpProvider({
    required this.baseUrl,
    required this.params,
  });

  // Todo Generate Uid
  // String generateUid() {
  //   late Uuid uid = const Uuid();
  //   return uid.v4().replaceAll(RegExp('-'), '');
  // }

  // Todo Set Header
  Future<Map<String, String>> getHeaders() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    return headers;
  }

  // TODO Method post
  Future<Map<String, dynamic>?> post({dynamic body}) async {
    dynamic responseJson;
    String stringUrl = "$baseUrl$params";
    final headers = await getHeaders();

    var client = RetryClient(
      http.Client(),
      retries: 3,
      onRetry: (req, res, retryCount) {
        if (res?.statusCode == 403) {
          // BaseApiProvider().navigateToLogout();
        }
      },
    );

    try {
      http.Response post = await client
          .post(Uri.parse(stringUrl), headers: headers, body: body)
          .timeout(Duration(milliseconds: AppConstant.timeoutMillisecond));

      responseJson = response(post);
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      client.close();
    }

    return responseJson;
  }

  // Todo Method get
  Future<Map<String, dynamic>?> get() async {
    dynamic responseJson;
    String stringUrl = "$baseUrl$params";
    final headers = await getHeaders();

    var client = RetryClient(
      http.Client(),
      retries: 3,
      onRetry: (req, res, retryCount) {
        if (res?.statusCode == 403) {
          // BaseApiProvider().navigateToLogout();
        }
      },
    );

    try {
      http.Response get = await client
          .get(Uri.parse(stringUrl), headers: headers)
          .timeout(Duration(milliseconds: AppConstant.timeoutMillisecond));

      responseJson = response(get);
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      client.close();
    }

    return responseJson;
  }


  // TODO Method post
  Future<Map<String, dynamic>?> patch({dynamic body}) async {
    dynamic responseJson;
    String stringUrl = "$baseUrl$params";
    final headers = await getHeaders();

    var client = RetryClient(
      http.Client(),
      retries: 3,
      onRetry: (req, res, retryCount) {
        if (res?.statusCode == 403) {
          // BaseApiProvider().navigateToLogout();
        }
      },
    );

    try {
      http.Response post = await client
          .patch(Uri.parse(stringUrl), headers: headers, body: body)
          .timeout(Duration(milliseconds: AppConstant.timeoutMillisecond));

      responseJson = response(post);
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      client.close();
    }

    return responseJson;
  }

  Future<Map<String, dynamic>?> postWithAbsenceImage({
    required dynamic body,
  }) async {
    dynamic responseJson;
    String stringUrl = "$baseUrl$params";
    final headers = await getHeaders();

    var client = RetryClient(
      http.Client(),
      retries: 3,
      onRetry: (req, res, retryCount) {
        if (res?.statusCode == 403) {
          // BaseApiProvider().navigateToLogout();
        }
      },
    );

    try {
      var request = http.MultipartRequest('POST', Uri.parse(stringUrl));

      request.headers.addAll(headers);
      request.fields.addAll({
        'spg_id': body['spg_id'],
        'spg_name': body['spg_name'],
        'store_id': body['store_id'],
        'store_name': body['store_name'],
        'date': body['date'],
        'time': body['time'],
        'type': body['type'],
        'latt': body['latt'],
        'long': body['long'],
        'user_login': body['user_login'],
      });

      request.files
          .add(await http.MultipartFile.fromPath('image', body['image']));

      http.StreamedResponse streamedResponse = await client.send(request);

      http.Response postResponse =
          await http.Response.fromStream(streamedResponse);

      responseJson = response(postResponse);
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      client.close();
    }

    return responseJson;
  }

  Future<Map<String, dynamic>?> postWithVisitsImage({
    required Map<String, dynamic> body,
  }) async {
    dynamic responseJson;
    String stringUrl = "$baseUrl$params";
    final headers = await getHeaders();

    var client = RetryClient(
      http.Client(),
      retries: 3,
      onRetry: (req, res, retryCount) {
        if (res?.statusCode == 403) {
          // BaseApiProvider().navigateToLogout();
        }
      },
    );

    try {
      var request = http.MultipartRequest('POST', Uri.parse(stringUrl));

      request.headers.addAll(headers);
      request.fields.addAll({
        'store_id': body['store_id'],
        'store_name': body['store_name'],
        'store_type': body['store_type'],
        'note': body['note'],
        'in_date': body['in_date'],
        'in_time': body['in_time'],
        'in_lat': body['in_lat'],
        'in_long': body['in_long'],
        'out_date': body['out_date'] ?? '',
        'out_time': body['out_time'] ?? '',
        'out_lat': body['out_lat'] ?? '',
        'out_long': body['out_long'] ?? '',
        'user_login': body['user_login'],
      });

      request.files
          .add(await http.MultipartFile.fromPath('image', body['image']));

      http.StreamedResponse streamedResponse = await client.send(request);

      http.Response postResponse =
          await http.Response.fromStream(streamedResponse);

      responseJson = response(postResponse);
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      client.close();
    }

    return responseJson;
  }

}

dynamic response(http.Response response) {
  dynamic data = jsonDecode(response.body.toString());
  log("data : ${const JsonEncoder.withIndent(' ').convert(data)}");
  log("STATUSCODE : ${response.statusCode}");

  switch (response.statusCode) {
    case 200:
    case 201:
      dynamic data = jsonDecode(response.body.toString());
      return Response(
        responseCode: response.statusCode,
        data: data,
        message: "",
      ).toJson();
    case 400:
      dynamic data = jsonDecode(response.body.toString());
      return Response(
        responseCode: response.statusCode,
        message: data["message"] ?? data['responseText'],
      ).toJson();
    case 401:
      dynamic data = jsonDecode(response.body.toString());
      return Response(
        responseCode: response.statusCode,
        message: data["message"],
        data: data,
      ).toJson();
    // case 403:
    //   dynamic data = jsonDecode(response.body.toString());
    //   log(data.toString());
    //   throw UnauthorizedException(message: data["message"]);
    case 404:
      dynamic data = jsonDecode(response.body.toString());
      return Response(
        responseCode: response.statusCode,
        message: data["message"],
      ).toJson();
    case 500:
    case 504:
      dynamic data = jsonDecode(response.body.toString());
      return Response(
        responseCode: response.statusCode,
        message: data["message"],
      ).toJson();
    default:
      dynamic data = jsonDecode(response.body.toString());
      return Response(
        responseCode: response.statusCode,
        message: data["message"],
      ).toJson();
  }
}

// void showErrorDialog(dynamic data) {
//   BuildContext mContext = AppConstant.navigatorKey.currentContext!;
//   Language language = Language.of(mContext)!;
//   showCustomBottomSheet(
//     context: mContext,
//     icon: 'assets/icons/ic_caution_red.svg',
//     title: language.messageGeneralError,
//     message: data["message"],
//     actionButton: [
//       Container(
//         width: MediaQuery.of(mContext).size.width,
//         margin: EdgeInsets.symmetric(
//           vertical: Util.basePaddingMargin4,
//           horizontal: Util.basePaddingMargin16,
//         ),
//         child: ButtonInfoLg(
//             title: language.labelConfirmBtn,
//             withIcon: false,
//             active: true,
//             margin: 0,
//             action: () {
//               Navigator.of(mContext).pop();
//             }),
//       ),
//     ],
//   );
// }

class Response {
  final int responseCode;
  final dynamic data;
  final dynamic message;

  Response({required this.responseCode, this.data, this.message});

  Map<String, dynamic> toJson() => <String, dynamic>{
        "responseCode": responseCode,
        "message": message,
        "data": data,
      };
}
