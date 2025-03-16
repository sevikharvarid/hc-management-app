// import 'dart:developer';

// import 'package:flutter_flipperkit/flutter_flipperkit.dart';

// class NetworkDebugger {
//   FlipperClient flipperClient = FlipperClient.getDefault();

//   NetworkDebugger();

//   Future<void> startNetworkDebugger() async {
//     try {
//       flipperClient.addPlugin(FlipperReduxInspectorPlugin());
//       flipperClient.addPlugin(FlipperSharedPreferencesPlugin());
//       flipperClient.addPlugin(FlipperNetworkPlugin());

//       flipperClient.start();
//     } on Exception catch (e) {
//       log(e.toString());
//     }
//   }

//   Future<void> stopNetworkDebugger() async {
//     flipperClient.stop();
//   }
// }
