import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hc_management_app/domain/model/stores.dart';
import 'package:hc_management_app/features/check_in/repository/check_in_repository.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';

part 'check_in_state.dart';

class CheckInCubit extends Cubit<CheckInState> {
  CheckInCubit() : super(CheckInInitial());

  CheckInRepository checkInRepository = CheckInRepository();
  GeneralHelper helpers = GeneralHelper();

  bool isChecked = false;
  bool isReadOnlyStore = false;

  List<DataStore> listToko = [];
  DataStore? dataStore;

  Position? userPosition;

  void initCubit() async {
    emit(CheckInLoading());

    userPosition = await helpers.getCurrentPosition();

    emit(CheckInLoaded());
  }

  void postData(String? imagePath) async {
    emit(CheckInLoading());
    var params = {
      'store_id': '1',
      'store_name': 'Toko Bang Jali',
      'date': '2024/03/13',
      'time': '20:00',
      'type': 'in',
      'latt': '12345',
      'long': '1234123',
      'user_login': '"{name:alvine}"',
      'image': imagePath,
    };

    final response = await checkInRepository.postSubmitData(params);
    log("response is : $response");

    emit(CheckInLoaded());
  }

  void setCheckBox(bool? value) async {
    isChecked = value!;

    if (isChecked) {
      isReadOnlyStore = true;
    } else {
      isReadOnlyStore = false;
    }
    emit(CheckInChecklistStore(
      state: isChecked,
    ));
  }

  void setIsReadOnlyStoreField(bool? value) async {
    isReadOnlyStore = value!;
    emit(CheckInChecklistStoreIsReadOnly(
      state: isReadOnlyStore,
    ));
  }

  void getStoreData() async {
    emit(CheckInFilterLoading());

    var params = {
      "id": 2,
      "nama_store": "Toko bangunan",
    };

    final response = await checkInRepository.getStoreData(params);
    final List<dynamic> responseData = response.data['data'];

    listToko = responseData.map((item) => DataStore.fromJson(item)).toList();

    emit(CheckInFilterLoaded());
  }
}
