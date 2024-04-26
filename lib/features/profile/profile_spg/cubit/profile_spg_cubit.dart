import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';

part 'profile_spg_state.dart';

class ProfileSPGCubit extends Cubit<ProfileSPGState> {
  ProfileSPGCubit() : super(ProfileSPGInitial());

  Preferences preferences = Preferences();

  void initCubit() async {
    emit(ProfileSPGLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(ProfileSPGLoaded());
  }

  void logout() async {
    emit(ProfileSPGLoading());
    await preferences.clear();
    emit(ProfileSPGLogout());
  }
}
