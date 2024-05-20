part of 'profile_spg_cubit.dart';

abstract class ProfileSPGState extends Equatable {
  const ProfileSPGState();
}

class ProfileSPGInitial extends ProfileSPGState {
  @override
  List<Object> get props => [];
}

class ProfileSPGLoading extends ProfileSPGState {
  @override
  List<Object> get props => [];
}

class ProfileSPGLoaded extends ProfileSPGState {
  @override
  List<Object> get props => [];
}

class ProfileSPGLogout extends ProfileSPGState {
  @override
  List<Object> get props => [];
}

class ProfileSetVisible extends ProfileSPGState {
  final bool? isVisible;

  const ProfileSetVisible({this.isVisible});
  @override
  List<Object> get props => [isVisible!];
}
