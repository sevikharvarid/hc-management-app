part of 'check_in_cubit.dart';

abstract class CheckInState extends Equatable {
  const CheckInState();
}

class CheckInInitial extends CheckInState {
  @override
  List<Object> get props => [];
}

class CheckInLoading extends CheckInState {
  @override
  List<Object> get props => [];
}

class CheckInLoaded extends CheckInState {
  @override
  List<Object> get props => [];
}

class CheckInChecklistStore extends CheckInState {
  final bool? state;

  const CheckInChecklistStore({this.state});

  @override
  List<Object> get props => [state!];
}

class CheckInChecklistStoreIsReadOnly extends CheckInState {
  final bool? state;

  const CheckInChecklistStoreIsReadOnly({this.state});

  @override
  List<Object> get props => [state!];
}

class CheckInFilterLoading extends CheckInState {
  @override
  List<Object> get props => [];
}

class CheckInFilterLoaded extends CheckInState {
  @override
  List<Object> get props => [];
}
