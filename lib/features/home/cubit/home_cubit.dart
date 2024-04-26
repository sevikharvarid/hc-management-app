import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hc_management_app/domain/model/menus.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  List<Menus>? menus = [];

  void initCubit() async {
    emit(HomeLoading());
    menus = [
      Menus(
        menuTitle: "List Toko",
        iconData: Icons.list_alt_rounded,
        iconColor: AppColors.yellow,
      ),
      Menus(
        menuTitle: "Other\nToko",
        iconData: Icons.person_add_alt_1,
        iconColor: AppColors.orange,
      ),
      Menus(
        menuTitle: "Note\nKunjungan",
        iconData: Icons.av_timer,
        iconColor: AppColors.blue70,
      ),
      Menus(
        menuTitle: "Orderan\nSO",
        iconData: Icons.note_alt_rounded,
        iconColor: AppColors.green,
      ),
    ];
    emit(HomeLoaded());
  }
}
