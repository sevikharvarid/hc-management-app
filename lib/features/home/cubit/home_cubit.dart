import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hc_management_app/features/home/repository/home_sales_repository.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences_key.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  
  String? name;
  String? photoProfile = '';

  Preferences preferences = Preferences();
  HomeSalesRepository homeSalesRepository = HomeSalesRepository();


  void initCubit() async {
    emit(HomeLoading());

    await Future.delayed(const Duration(seconds: 1));

    name = await preferences.read(PreferencesKey.name);

    photoProfile = await preferences.read(PreferencesKey.profilePhoto);

    var params = {};

    var response = await homeSalesRepository.getHistoryVisits(params);

    log("RESPONSE : ${response.data}");
  
 
    emit(HomeLoaded());
  }



  
}
