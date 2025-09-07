part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoaded extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeNavigateLoaded extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeNavigateOrderLoaded extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeSuccessGet extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeStoreFilterLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeStoreFilterLoaded extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeStoreChecklistStore extends HomeState {
  final bool? state;

  const HomeStoreChecklistStore({this.state});

  @override
  List<Object> get props => [state!];
}
