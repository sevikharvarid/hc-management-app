import 'package:equatable/equatable.dart';

abstract class OrderOnlySalesState extends Equatable {
  const OrderOnlySalesState();
}

class InputSOInitial extends OrderOnlySalesState {
  @override
  List<Object> get props => [];
}

class InputSOLoading extends OrderOnlySalesState {
  @override
  List<Object> get props => [];
}

class InputSOLoaded extends OrderOnlySalesState {
  @override
  List<Object> get props => [];
}

class ListProductLoading extends OrderOnlySalesState {
  @override
  List<Object> get props => [];
}

class ListProductLoaded extends OrderOnlySalesState {
  @override
  List<Object> get props => [];
}

class InputAddingProductLoading extends OrderOnlySalesState {
  @override
  List<Object> get props => [];
}

class InputAddingProductLoaded extends OrderOnlySalesState {
  final List<String>? datas;

  const InputAddingProductLoaded({this.datas});
  @override
  List<Object> get props => [datas!];
}

class InputAddingProductFailed extends OrderOnlySalesState {
  @override
  List<Object> get props => [];
}

class InputAddingProductAlreadyExist extends OrderOnlySalesState {
  @override
  List<Object> get props => [];
}

class SaveProductLoading extends OrderOnlySalesState {
  @override
  List<Object> get props => [];
}

class SaveProductLoaded extends OrderOnlySalesState {
  @override
  List<Object> get props => [];
}

class SaveProductFailed extends OrderOnlySalesState {
  @override
  List<Object> get props => [];
}

class RemoveProductLoading extends OrderOnlySalesState {
  @override
  List<Object> get props => [];
}

class RemoveProductLoaded extends OrderOnlySalesState {
  @override
  List<Object> get props => [];
}
