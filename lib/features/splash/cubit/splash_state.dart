part of 'splash_cubit.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashInitial extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashLoading extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashLoaded extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashAuthenticated extends SplashState {
  final String? userType;

  const SplashAuthenticated({this.userType});
  @override
  List<Object?> get props => [userType!];
}

class SplashUnauthenticated extends SplashState {
  @override
  List<Object?> get props => [];
}
