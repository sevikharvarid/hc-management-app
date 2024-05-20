import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hc_management_app/features/profile/repository/profile_repository.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';

part 'profile_spg_state.dart';

class ProfileSPGCubit extends Cubit<ProfileSPGState> {
  ProfileSPGCubit() : super(ProfileSPGLoading());

  Preferences preferences = Preferences();
  ProfileRepository profileRepository = ProfileRepository();

  String? name;
  String? nik;
  String? notes;
  String? role;

  String? photoProfile;
  bool? isVisible = false;

  void initCubit() async {

    var params = await preferences.read(PreferencesKey.userId);


    emit(ProfileSPGLoading());
    
    var response = await profileRepository.getProfile(params);

    name = response.data['name'];
    notes = response.data['notes'];
    nik = response.data['nik'];
    role = response.data['role'];
    photoProfile = response.data["photo"];

    await preferences.store(
        PreferencesKey.profilePhoto, photoProfile.toString());

    emit(ProfileSPGLoaded());
  }

  void updateProfile(dynamic params) async {
    emit(ProfileSPGLoading());
    var response = await profileRepository.updateProfile(params);
    log("response : ${response.data}");
    emit(ProfileSPGLoaded());
  }

  void logout() async {
    emit(ProfileSPGLoading());
    await preferences.clear();
    emit(ProfileSPGLogout());
  }

  void setVisibile() {
    isVisible = !isVisible!;
    emit(ProfileSetVisible(isVisible: isVisible));
  }


}
