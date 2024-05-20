import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hc_management_app/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:hc_management_app/features/home/cubit/home_cubit.dart';
import 'package:hc_management_app/features/home/ui/home_page.dart';
import 'package:hc_management_app/features/profile/profile_sales/cubit/profile_sales_cubit.dart';
import 'package:hc_management_app/features/profile/profile_sales/ui/profile_sales_page.dart';
import 'package:hc_management_app/features/request/request_sales/cubit/request_sales_cubit.dart';
import 'package:hc_management_app/features/request/request_sales/ui/request_sales_page.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/widgets/appbar/fab_button_appbar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();
    return Scaffold(
      body: BlocConsumer<DashboardCubit, DashboardState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is DashboardHome) {
            return BlocProvider<HomeCubit>(
              create: (context) => HomeCubit()..initCubit(),
              child: HomePage(
                onClickViewAll: () {
                  cubit.changePage(1);
                },
              ),
            );
          }
          if (state is DashboardRequest) {
            return BlocProvider<RequestSalesCubit>(
              create: (context) => RequestSalesCubit()..initCubit(),
              child: const RequestSalesPage(),
            );
          }
          if (state is DashboardProfile) {
            return BlocProvider<ProfileSalesCubit>(
              create: (context) => ProfileSalesCubit()..initCubit(),
              child: const ProfileSalesPage(),
            );
          }
          return Scaffold(
            body: Container(),
          );
        },
      ),
      bottomNavigationBar: FABBottomAppBar(
        notchedShape: const CircularNotchedRectangle(),
        selectedColor: AppColors.primary,
        color: Colors.grey,
        onTabSelected: (i) {
          cubit.changePage(i);
        },
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.notifications, text: 'Request'),
          FABBottomAppBarItem(iconData: Icons.person, text: 'Profile'),
        ],
      ),
    );
  }
}
