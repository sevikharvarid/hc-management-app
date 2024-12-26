part of 'check_out_sales_cubit.dart';

abstract class CheckOutSalesState extends Equatable {
  const CheckOutSalesState();
}

class CheckOutSalesInitial extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}


class CheckOutSalesLoading extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class CheckOutSalesLoaded extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}


class CheckOutSalesCheckout extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class CheckOutSalesCheckoutFailed extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class CheckOutSalesCheckoutSuccess extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class CheckOutSalesInputSO extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}



class InputSOLoading extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class InputSOLoaded extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class ListProductLoading extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class ListProductLoaded extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class InputAddingProductLoading extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class InputAddingProductLoaded extends CheckOutSalesState {
  final List<String>? datas;

  const InputAddingProductLoaded({this.datas});
  @override
  List<Object> get props => [datas!];
}

class InputAddingProductFailed extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class InputAddingProductAlreadyExist extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class SaveProductLoading extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class SaveProductLoaded extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class SaveProductFailed extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class RemoveProductLoading extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}

class RemoveProductLoaded extends CheckOutSalesState {
  @override
  List<Object> get props => [];
}
