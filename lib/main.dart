import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hc_management_app/config/app.dart';
import 'package:hc_management_app/features/face_recognition/services/locator/locator.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupServices();

  // NetworkDebugger().startNetworkDebugger();

  // Minta izin akses lokasi
  await requestLocationPermission();

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

// Future<void> requestLocationPermission() async {
//   var status = await Permission.location.request();

//   if (status.isGranted) {
//     log('Izin lokasi diberikan');
//   } else if (status.isDenied) {
//     log('Izin lokasi ditolak');
//     // Informasikan pengguna tentang pentingnya izin lokasi dan tawarkan opsi untuk mengizinkannya
//   } else if (status.isPermanentlyDenied) {
//     log('Izin lokasi ditolak secara permanen');
//     // Berikan informasi kepada pengguna tentang cara membuka pengaturan aplikasi untuk mengizinkan izin lokasi
//   }
// }

/// **Meminta izin lokasi sebelum aplikasi berjalan**
Future<void> requestLocationPermission() async {
  // Cek apakah lokasi diaktifkan
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    log('Layanan lokasi tidak aktif. Minta pengguna untuk mengaktifkan.');
    return;
  }

  // Cek izin lokasi yang sudah ada
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      log('Izin lokasi ditolak oleh pengguna.');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    log('Izin lokasi ditolak secara permanen. Arahkan ke pengaturan.');
    await openAppSettings(); // Membuka pengaturan aplikasi
    return;
  }

  log('Izin lokasi diberikan.');
}
