part of 'request_sales_cubit.dart';

abstract class RequestSalesState extends Equatable {
  const RequestSalesState();
}

class RequestSalesInitial extends RequestSalesState {
  @override
  List<Object> get props => [];
}

class RequestSalesLoading extends RequestSalesState {
  @override
  List<Object> get props => [];
}

class RequestSalesLoaded extends RequestSalesState {
  @override
  List<Object> get props => [];
}
