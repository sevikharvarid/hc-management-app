import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'request_sales_state.dart';

class RequestSalesCubit extends Cubit<RequestSalesState> {
  RequestSalesCubit() : super(RequestSalesInitial());

  void initCubit() {
    emit(RequestSalesLoading());
    emit(RequestSalesLoaded());
  }
}
