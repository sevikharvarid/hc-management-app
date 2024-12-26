import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hc_management_app/features/profile/repository/profile_repository.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';

part 'profile_sales_state.dart';

class ProfileSalesCubit extends Cubit<ProfileSalesState> {
  ProfileSalesCubit() : super(ProfileSalesInitial());

 
  Preferences preferences = Preferences();
  ProfileRepository profileRepository = ProfileRepository();

  String? name;
  String? nik;
  String? notes;
  String? role;
  int? logoutStatus;

  String? photoProfile;
  bool? isVisible = false;

  void initCubit() async {

    var params = await preferences.read(PreferencesKey.userId);

    emit(ProfileSalesLoading());

    var response = await profileRepository.getProfile(params);

    name = response.data['name'];
    notes = response.data['notes'];
    nik = response.data['nik'];
    role = response.data['role'];
    photoProfile = response.data["photo"];
    logoutStatus = response.data['logout_status'];

    if (photoProfile != null) {
      await preferences.store(
          PreferencesKey.profilePhoto, photoProfile.toString());
    }

    emit(ProfileSalesLoaded());
  }

  void updateProfile(dynamic params) async {
    emit(ProfileSalesLoading());
    var response = await profileRepository.updateProfile(params);
    log("response : ${response.data}");
    emit(ProfileSalesLoaded());
  }

  void logout() async {
    emit(ProfileSalesLoading());
    await Future.delayed(const Duration(seconds: 1));
    await preferences.clear();
    FlutterBackgroundService().invoke('stopService');
    emit(ProfileSalesLogout());
  }

  void setVisibile() {
    isVisible = !isVisible!;
    emit(ProfileSetVisible(isVisible: isVisible));
  }

}
