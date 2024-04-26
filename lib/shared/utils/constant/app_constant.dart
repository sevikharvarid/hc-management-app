library general_helper;

import 'package:flutter/material.dart';

class AppConstant {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static int get minScore => 500;

  static int get timeoutMillisecond => 60000;

  static int timeOutDuration = 40;
  static RegExp emailValidate =
      RegExp(r'^[a-z]+[A-Z]+[0-9]+[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  static String locale = "id_ID";
}
