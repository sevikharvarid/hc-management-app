import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';
import 'package:http/http.dart' as http;

Preferences preferences = Preferences();
GeneralHelper generalHelper = GeneralHelper();

Future<void> postLocation() async {
  var headers = {'Content-Type': 'application/json'};

  var url = Uri.parse('http://103.140.34.220:280/api/locations');

  String userId = await preferences.read(PreferencesKey.userId);
  Position position = await generalHelper.getCurrentPosition();

  log("latitude : ${position.latitude}");
  log("longitude : ${position.longitude}");

  var locationData = json.encode(
    {
      "user_id": int.parse(userId),
      "latt": "-6.2259782759986315",
      "long": "107.00108712484398",
    },
  );

  var response = await http.post(
    url,
    headers: headers,
    body: locationData,
  );

  if (response.statusCode == 201) {
    log('Request successful');
    log(response.body);
  } else {
    log('Request failed with status: ${response.statusCode}');
    log(response.reasonPhrase.toString());
  }
}

Future<void> getLocations() async {
  String? userId = await preferences.read(PreferencesKey.userId);
  log("user id is : $userId");

  var url =
      Uri.parse('http://103.140.34.220:280/api/intervals?user_id=$userId');

  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      // Mengakses nilai dalam objek Map
      var success = jsonResponse['success'];
      var message = jsonResponse['message'];
      var data = jsonResponse['data'];

      if (success) {
        log('Success: $message');
        // Lakukan sesuatu dengan data di sini
        log('Data: ${data['data'][0]['interval']}');
        log('Data: ${data['data'][0]['interval'].runtimeType}');
        await preferences.store(
            PreferencesKey.interval, data['data'][0]['interval'].toString());
      } else {
        log('Request failed with message: $message');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Request failed with error: $e');
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  log("mulai di sini");

  String? intervalSeconds =
      await preferences.read(PreferencesKey.interval) ?? '5';

  Timer.periodic(Duration(seconds: int.parse(intervalSeconds!)), (timer) async {
    log("Checking interval and user ID...");
    getLocations();
    String? newIntervalSeconds =
        await preferences.read(PreferencesKey.interval);

    // Jika interval baru tersedia, perbarui nilai intervalSeconds
    if (newIntervalSeconds != null) {
      intervalSeconds = newIntervalSeconds;
      log("Interval updated: $intervalSeconds");
    }

    // Lakukan pengecekan terhadap user ID di sini
    // if (userIdIsAvailable()) {
    //   log("User ID is available, posting location...");
    //   postLocation();
    // }
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  return false;
}

class BackgroundService {
  static final BackgroundService instance = BackgroundService._internal();
  factory BackgroundService() {
    return instance;
  }

  BackgroundService._internal();

  Future init() async {
    final service = FlutterBackgroundService();
    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
      ),
    );
    await service.startService();
  }
}
