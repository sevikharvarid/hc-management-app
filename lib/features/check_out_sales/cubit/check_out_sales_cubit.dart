import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'check_out_sales_state.dart';

class CheckOutSalesCubit extends Cubit<CheckOutSalesState> {
  CheckOutSalesCubit() : super(CheckOutSalesInitial());

  late int? currentIndex = 0;

  void initCubit() async {
    if (currentIndex == 0) {
      // state form
      emit(CheckOutSalesCheckout());
      return;
    }

    if (currentIndex == 1) {
      // state history
      emit(CheckOutSalesInputSO());
      return;
    }
  }

  void changePage({int? index}) async {
    currentIndex = index!;

    if (currentIndex == 0) {
      // state form
      emit(CheckOutSalesCheckout());
      return;
    }

    if (currentIndex == 1) {
      // state history
      emit(CheckOutSalesInputSO());
      return;
    }
  }
}
