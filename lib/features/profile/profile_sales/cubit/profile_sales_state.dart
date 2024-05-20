part of 'profile_sales_cubit.dart';

abstract class ProfileSalesState extends Equatable {
  const ProfileSalesState();
}

class ProfileSalesInitial extends ProfileSalesState {
  @override
  List<Object> get props => [];
}

class ProfileSalesLoading extends ProfileSalesState {
  @override
  List<Object> get props => [];
}

class ProfileSalesLoaded extends ProfileSalesState {
  @override
  List<Object> get props => [];
}

class ProfileSalesLogout extends ProfileSalesState {
  @override
  List<Object> get props => [];
}

class ProfileSetVisible extends ProfileSalesState {
  final bool? isVisible;

  const ProfileSetVisible({this.isVisible});
  @override
  List<Object> get props => [isVisible!];
}
