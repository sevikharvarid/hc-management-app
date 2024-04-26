part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoaded extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccessSalesDashboard extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccessSPGDashboard extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginFailed extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginError extends LoginState {
  final String? message;

  const LoginError({this.message});
  @override
  List<Object> get props => [message!];
}

class LoginSetVisible extends LoginState {
  final bool? isVisible;

  const LoginSetVisible({this.isVisible});
  @override
  List<Object> get props => [isVisible!];
}
