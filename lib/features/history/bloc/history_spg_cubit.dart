import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hc_management_app/domain/model/absence.dart';
import 'package:hc_management_app/features/history/bloc/history_spg_state.dart';
import 'package:hc_management_app/features/history/repository/history_spg_repository.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';

class HistorySPGCubit extends Cubit<HistorySPGState> {
  HistorySPGCubit() : super(HistorySPGLoading());

  String? userId;

  Preferences preferences = Preferences();
  GeneralHelper generalHelper = GeneralHelper();
  HistorySPGRepository historySPGRepository = HistorySPGRepository();

  List<Absence> absenceList = [];

  void initCubit() async {
    userId = await preferences.read(PreferencesKey.userId);

    emit(HistorySPGLoading());

    var params = {
      "store_id": "",
      "type": "",
      "date_start": "",
      "date_end": "",
      "search": "",
    };

    final response = await historySPGRepository.getHistoryAbsence(params);

    absenceList = (response.data["data"] as List)
        .map((e) => Absence.fromJson(e))
        .toList();

    emit(HistorySPGLoaded());
  }
}
