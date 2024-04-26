import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  int? currentIndex;
  DashboardCubit() : super(DashboardInitial());

  FutureOr<void> changePage(
    int? index,
  ) async {
    currentIndex = index!;

    if (index == 0) {
      emit(DashboardHome());
    }

    if (index == 1) {
      emit(DashboardRequest());
    }

    if (index == 2) {
      emit(DashboardProfile());
    }
  }
}
