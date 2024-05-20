import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hc_management_app/domain/model/absence.dart';
import 'package:hc_management_app/features/history/bloc/history_spg_state.dart';
import 'package:hc_management_app/features/history/repository/history_spg_repository.dart';
import 'package:hc_management_app/shared/utils/constant/app_constant.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/utils/helpers/month_pickers.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';
import 'package:intl/intl.dart';

class HistorySPGCubit extends Cubit<HistorySPGState> {
  HistorySPGCubit() : super(HistorySPGLoading());

  String? userId;
  bool? stateDateEnd = false;

  Preferences preferences = Preferences();
  GeneralHelper generalHelper = GeneralHelper();
  HistorySPGRepository historySPGRepository = HistorySPGRepository();
  
  late BuildContext mContext = AppConstant.navigatorKey.currentContext!;

  final monthController = TextEditingController();

  List<Absence> absenceList = [];

  TextEditingController dateStart = TextEditingController();
  TextEditingController dateEnd = TextEditingController();
  final searchController = TextEditingController();


  void initCubit() async {
    userId = await preferences.read(PreferencesKey.userId);

    emit(HistorySPGLoading());

    monthController.text = initialMonth(mContext)!;

    var storeId = await preferences.read(PreferencesKey.storeId);

    await Future.delayed(const Duration(seconds: 1));

    var params = {
      "store_id": storeId,
      "type": "",
      "date_start":
          generalHelper.getMonthStartAndEndDate(monthController.text).first,
      "date_end":
          generalHelper.getMonthStartAndEndDate(monthController.text).last,
      "search": "",
    };

    final response = await historySPGRepository.getHistoryAbsence(params);

    absenceList = (response.data["data"] as List)
        .map((e) => Absence.fromJson(e))
        .toList();

    emit(HistorySPGLoaded());
  }

  void saveMonth() async {
    emit(HistorySPGLoading());

    var storeId = await preferences.read(PreferencesKey.storeId);

    var params = {
      "store_id": storeId,
      "type": "",
      "date_start": formatDate(parseDate(dateStart.text)),
      "date_end": formatDate(parseDate(dateEnd.text)),
      "search": "",
    };

    final response = await historySPGRepository.getHistoryAbsence(params);

    absenceList = (response.data["data"] as List)
        .map((e) => Absence.fromJson(e))
        .toList();

    emit(HistorySPGLoaded());
  }

  void findSPG(String? value) async {
    emit(HistorySPGLoading());

    var storeId = await preferences.read(PreferencesKey.storeId);
    var params = {};

    if (dateStart.text.isEmpty || dateStart.text.isEmpty) {
      params = {
        "store_id": storeId,
        "type": "",
        "date_start": generalHelper.convertDateToString(
          dateTime: DateTime.now(),
          dateFormat: "yyyy/MM/dd",
        ),
        "date_end": generalHelper.convertDateToString(
          dateTime: DateTime.now(),
          dateFormat: "yyyy/MM/dd",
        ),
        "search": value,
      };
    } else {
      params = {
        "store_id": storeId,
        "type": "",
        "date_start": formatDate(parseDate(dateStart.text)),
        "date_end": formatDate(parseDate(dateEnd.text)),
        "search": value,
      };
    }

    final response = await historySPGRepository.getHistoryAbsence(params);

    absenceList = (response.data["data"] as List)
        .map((e) => Absence.fromJson(e))
        .toList();

    emit(HistorySPGLoaded());
  }

  void changeState() async {
    stateDateEnd = true;
    emit(const HistoryChangeState());
  }

  DateTime parseDate(String dateString) {
    // Format tanggal yang digunakan
    DateFormat dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    return dateFormat.parse(dateString);
  }

  String formatDate(DateTime date) {
    // Format tanggal yang diinginkan
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    return dateFormat.format(date);
  }

}
