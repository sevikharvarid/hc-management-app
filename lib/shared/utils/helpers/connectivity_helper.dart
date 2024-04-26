import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  late bool isConnected = true;
  late Connectivity connectivity = Connectivity();
  late ConnectivityResult connectivityResult;

  Future<bool> checkConnectivityStatus() async {
    connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      isConnected = false;
    }

    if (connectivityResult == ConnectivityResult.mobile) {
      isConnected = true;
    }

    if (connectivityResult == ConnectivityResult.wifi) {
      isConnected = true;
    }

    return isConnected;
  }
}
