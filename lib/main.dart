import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hc_management_app/config/app.dart';
import 'package:hc_management_app/features/face_recognition/services/locator/locator.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  setupServices();

  WidgetsFlutterBinding.ensureInitialized();

  // Minta izin akses lokasi
  await requestLocationPermission();

  // // Inisialisasi layanan latar belakang jika izin diberikan
  // if (await Permission.location.isGranted) {
  //   await BackgroundService.instance.init();
  // }

  initializeDateFormatting('id_ID');

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async => runApp(const MyApp()));
}

Future<void> requestLocationPermission() async {
  var status = await Permission.location.request();

  if (status.isGranted) {
    log('Izin lokasi diberikan');
  } else if (status.isDenied) {
    log('Izin lokasi ditolak');
    // Informasikan pengguna tentang pentingnya izin lokasi dan tawarkan opsi untuk mengizinkannya
  } else if (status.isPermanentlyDenied) {
    log('Izin lokasi ditolak secara permanen');
    // Berikan informasi kepada pengguna tentang cara membuka pengaturan aplikasi untuk mengizinkan izin lokasi
  }
}
