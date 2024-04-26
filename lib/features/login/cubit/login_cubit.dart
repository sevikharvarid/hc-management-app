import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hc_management_app/domain/model/users.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/features/login/repository/login_repository.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  Users? responseuser;
  bool? isVisible = false;
  LoginCubit() : super(LoginLoading());

  Preferences preferences = Preferences();
  LoginRepository loginRepository = LoginRepository();

  void setVisibile() {
    isVisible = !isVisible!;
    emit(LoginSetVisible(isVisible: isVisible));
  }

  void postLogin({String? nik, String? password}) async {
    try {
      emit(LoginLoading());
      var params = {
        "nik": "$nik",
        "password": "$password",
      };

      final response = await loginRepository.postLogin(params);
      if (response.data['data'] == null) {
        emit(LoginError(
          message: response.data['message'],
        ));
        return;
      }

      if (response.status == Status.success) {
        Users responseUser = usersFromJson(json.encode(response.data));

        Map<String, dynamic> createdByMap =
            jsonDecode(responseUser.data.createdBy.toString());

        await preferences.store(PreferencesKey.name, responseUser.data.name);
        await preferences.store(
            PreferencesKey.userId, responseUser.data.id.toString());

        // String? userId = await preferences.read(PreferencesKey.userId);

        await preferences.store(
            PreferencesKey.userLogin, createdByMap.toString());

        await preferences.store(
            PreferencesKey.userType, responseUser.data.type.toString());

        if (responseUser.data.type == 'sales') {
          emit(LoginSuccessSalesDashboard());
        } else if (responseUser.data.type == 'spg') {
          emit(LoginSuccessSPGDashboard());
        }

        return;
      }

      if (response.status == Status.error) {
        emit(LoginFailed());
        return;
      }
      emit(LoginLoaded());
    } on Exception catch (e) {
      log("Error is $e");
    }
  }
}
