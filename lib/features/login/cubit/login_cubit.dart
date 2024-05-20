import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hc_management_app/domain/model/users.dart';
import 'package:hc_management_app/domain/service/data_response.dart';
import 'package:hc_management_app/features/login/repository/login_repository.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';
import 'package:http/http.dart' as http;

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
        log(const JsonEncoder.withIndent('  ').convert(responseUser.data));

        Map<String, dynamic> createdByMap =
            jsonDecode(responseUser.data.createdBy.toString());

        // Map<String, dynamic> storeByMap =
        //     jsonDecode(responseUser.data.createdBy.toString());

        await preferences.store(PreferencesKey.name, responseUser.data.name);
        await preferences.store(
            PreferencesKey.userId, responseUser.data.id.toString());

        // String? userId = await preferences.read(PreferencesKey.userId);

        await preferences.store(
            PreferencesKey.userLogin, createdByMap.toString());

        await preferences.store(
            PreferencesKey.userType, responseUser.data.type.toString());

        if (responseUser.store != null) {
          await preferences.store(
              PreferencesKey.storeId, responseUser.store!.id.toString());
        }

        if (responseUser.data.photo != null) {
          await preferences.store(
              PreferencesKey.profilePhoto, responseUser.data.photo.toString());
        }
          

        if (responseUser.data.type == 'sales') {
          emit(LoginSuccessSalesDashboard());
        } else if (responseUser.data.type == 'spg') {
          updateUser(
            userId: responseUser.data.id.toString(),
            name: responseUser.data.name.toString(),
            nik: responseUser.data.nik.toString(),
            notes: responseUser.data.notes.toString(),
          );
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

  Future<void> updateUser({
    String? userId,
    String? name,
    String? nik,
    String? notes,
  }) async {
    var headers = {'Content-Type': 'application/json'};
    var url = 'http://103.140.34.220:280/api/users/$userId';

    try {
      var response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: json.encode({
          "name": name,
          "type": "spg",
          "role": "supervisor",
          "nik": nik,
          "notes": notes,
          "password": generateRandomString(10),
        }),
      );

      if (response.statusCode == 200) {
        log(response.body);
      } else {
        log('Failed to update user: ${response.reasonPhrase}');
      }
    } catch (e) {
      log('Error updating user: $e');
    }
  }

  String generateRandomString(int length) {
    const characters =
        "abcdefghijklmnopqrstuvwxyz0123456789-+/[];|,.<!@#%^&**()";
    final random = math.Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }
}
