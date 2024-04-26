import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Preferences preferences = Preferences();

  void initCubit() async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 1));

    String? userId = await preferences.read(PreferencesKey.userId);

    String? userType = await preferences.read(PreferencesKey.userType);

    if (userId == null) {
      emit(SplashUnauthenticated());
      return;
    } else {
      emit(SplashAuthenticated(
        userType: userType,
      ));
      return;
    }
  }
}
