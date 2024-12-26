part of 'home_spg_cubit.dart';

abstract class HomeSpgState extends Equatable {
  const HomeSpgState();
}

class HomeSpgInitial extends HomeSpgState {
  @override
  List<Object> get props => [];
}

class HomeSpgLoading extends HomeSpgState {
  @override
  List<Object> get props => [];
}

class HomeSpgLoaded extends HomeSpgState {
  @override
  List<Object> get props => [];
}

class HomeSpgLocationDetected extends HomeSpgState {
  @override
  List<Object> get props => [];
}

class HomeSpgSuccessLoaded extends HomeSpgState {
  @override
  List<Object> get props => [];
}

class HomeSpgSuccess extends HomeSpgState {
  final String? message;

  const HomeSpgSuccess({this.message});
  @override
  List<Object> get props => [message!];
}

class HomeSpgFailed extends HomeSpgState {
  final String? message;

  const HomeSpgFailed({this.message});
  @override
  List<Object> get props => [message!];
}

class HomeSpgImageSaved extends HomeSpgState {
  final String? imagePath;

  const HomeSpgImageSaved({this.imagePath});

  @override
  List<Object> get props => [imagePath!];
}

class HomeSpgFilterLoading extends HomeSpgState {
  @override
  List<Object> get props => [];
}

class HomeSpgFilterLoaded extends HomeSpgState {
  @override
  List<Object> get props => [];
}

class LocationServiceInitial extends HomeSpgState {
  @override
  List<Object> get props => [];
}

class LocationServiceLoading extends HomeSpgState {
  @override
  List<Object> get props => [];
}

class LocationServiceAvailable extends HomeSpgState {
  @override
  List<Object> get props => [];
}

class LocationServiceUnavailable extends HomeSpgState {
  @override
  List<Object> get props => [];
}
