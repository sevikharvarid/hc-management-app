import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hc_management_app/features/dashboardspg/cubit/dashboard_spg_cubit.dart';
import 'package:hc_management_app/features/homespg/cubit/home_spg_cubit.dart';
import 'package:hc_management_app/features/homespg/ui/home_spg_page.dart';
import 'package:hc_management_app/features/profile/profile_spg/cubit/profile_spg_cubit.dart';
import 'package:hc_management_app/features/profile/profile_spg/ui/profile_spg_page.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/widgets/appbar/fab_button_appbar.dart';

class DashboardSPGPage extends StatefulWidget {
  const DashboardSPGPage({
    super.key,
  });

  @override
  State<DashboardSPGPage> createState() => _DashboardSPGPageState();
}

class _DashboardSPGPageState extends State<DashboardSPGPage> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardSPGCubit>();
    return Scaffold(
        body: BlocConsumer<DashboardSPGCubit, DashboardSPGState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is DashboardSPGHome) {
              return BlocProvider<HomeSpgCubit>(
                create: (context) => HomeSpgCubit()..initCubit(),
                child: const HomeSpgPage(),
              );
            }
      
            if (state is DashboardSPGProfile) {
              log("tes");
              return BlocProvider<ProfileSPGCubit>(
                create: (context) => ProfileSPGCubit()..initCubit(),
                child: const ProfileSPGPage(),
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
            FABBottomAppBarItem(iconData: Icons.notifications, text: 'History'),
            FABBottomAppBarItem(iconData: Icons.person, text: 'Profile'),
          ],
        ),
      
    );
  }
}
