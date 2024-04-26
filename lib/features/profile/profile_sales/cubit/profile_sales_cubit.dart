import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_sales_state.dart';

class ProfileSalesCubit extends Cubit<ProfileSalesState> {
  ProfileSalesCubit() : super(ProfileSalesInitial());

  void initCubit() async {
    emit(ProfileSalesLoading());
    emit(ProfileSalesLoaded());
  }
}
