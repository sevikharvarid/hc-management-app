import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_spg_state.dart';

class DashboardSPGCubit extends Cubit<DashboardSPGState> {
  int? currentIndex;
  DashboardSPGCubit() : super(DashboardSPGInitial());

  FutureOr<void> changePage(
    int? index,
  ) async {
    currentIndex = index!;

    if (index == 0) {
      emit(DashboardSPGHome());
    }

    if (index == 1) {
      emit(DashboardSPGHistory());
    }

    if (index == 2) {
      emit(DashboardSPGProfile());
    }
  }
}
