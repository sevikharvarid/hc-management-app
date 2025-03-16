part of 'order_only_cubit.dart';

abstract class OrderOnlyStoreState extends Equatable {
  const OrderOnlyStoreState();
}

class OrderOnlyStoreInitial extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class OrderOnlyStoreLoading extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class OrderOnlyStoreLoaded extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class OrderOnlyStoreSubmitLoaded extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class OrderOnlyStoreFailed extends OrderOnlyStoreState {
  final String? message;

  const OrderOnlyStoreFailed({this.message});
  @override
  List<Object> get props => [message!];
}

class OrderOnlyStoreSuccess extends OrderOnlyStoreState {
  final VisitData? data;

  const OrderOnlyStoreSuccess({this.data});

  @override
  List<Object> get props => [data!];
}

class OrderOnlyStoreChecklistStore extends OrderOnlyStoreState {
  final bool? state;

  const OrderOnlyStoreChecklistStore({this.state});

  @override
  List<Object> get props => [state!];
}

class OrderOnlyStoreChecklistStoreIsReadOnly extends OrderOnlyStoreState {
  final bool? state;

  const OrderOnlyStoreChecklistStoreIsReadOnly({this.state});

  @override
  List<Object> get props => [state!];
}

class OrderOnlyStoreFilterLoading extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class OrderOnlyStoreFilterLoaded extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}


class OrderOnlyStoreSpgImageSaved extends OrderOnlyStoreState {
  final List<File>? imagePath;

  const OrderOnlyStoreSpgImageSaved({this.imagePath});

  @override
  List<Object> get props => [imagePath!];
}

// For input SO Below

class InputSOLoading extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class InputSOLoaded extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class ListProductLoading extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class ListProductLoaded extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class InputAddingProductLoading extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class InputAddingProductLoaded extends OrderOnlyStoreState {
  final List<String>? datas;

  const InputAddingProductLoaded({this.datas});
  @override
  List<Object> get props => [datas!];
}

class InputAddingProductFailed extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class InputAddingProductAlreadyExist extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class SaveProductLoading extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class SaveProductLoaded extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class SaveProductFailed extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class RemoveProductLoading extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}

class RemoveProductLoaded extends OrderOnlyStoreState {
  @override
  List<Object> get props => [];
}
