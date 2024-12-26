import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hc_management_app/config/routes.dart';
import 'package:hc_management_app/features/check_out_sales/cubit/check_out_sales_cubit.dart';
import 'package:hc_management_app/features/check_out_sales/ui/check_out_sales_main.dart';
import 'package:hc_management_app/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:hc_management_app/features/dashboard/ui/dashboard_page.dart';
import 'package:hc_management_app/features/dashboardspg/cubit/dashboard_spg_cubit.dart';
import 'package:hc_management_app/features/dashboardspg/ui/dashboard_spg_page.dart';
import 'package:hc_management_app/features/home/cubit/home_cubit.dart';
import 'package:hc_management_app/features/home/ui/home_page.dart';
import 'package:hc_management_app/features/homespg/cubit/home_spg_cubit.dart';
import 'package:hc_management_app/features/homespg/ui/home_spg_page.dart';
import 'package:hc_management_app/features/login/cubit/login_cubit.dart';
import 'package:hc_management_app/features/login/ui/login_page.dart';
import 'package:hc_management_app/features/order/cubit/order_only_cubit.dart';
import 'package:hc_management_app/features/order/ui/order_only_page.dart';
import 'package:hc_management_app/features/profile/profile_sales/cubit/profile_sales_cubit.dart';
import 'package:hc_management_app/features/profile/profile_sales/ui/profile_sales_page.dart';
import 'package:hc_management_app/features/profile/profile_spg/cubit/profile_spg_cubit.dart';
import 'package:hc_management_app/features/profile/profile_spg/ui/profile_spg_page.dart';
import 'package:hc_management_app/features/splash/cubit/splash_cubit.dart';
import 'package:hc_management_app/features/splash/ui/splash_page.dart';
import 'package:hc_management_app/shared/utils/constant/app_constant.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // return ScreenUtilInit(
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, __) => MaterialApp(
        navigatorKey: AppConstant.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: "HC Management App",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // navigatorKey: AppConstant.navigatorKey(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case Routes.landing:
              return CupertinoPageRoute(
                builder: (context) => BlocProvider<SplashCubit>(
                  create: (context) => SplashCubit()..initCubit(),
                  child: const SplashPage(),
                ),
              );
            case Routes.mainSales:
              return CupertinoPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => DashboardCubit()..changePage(0),
                  child: const DashboardPage(),
                ),
              );

            case Routes.mainSPG:
              return CupertinoPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => DashboardSPGCubit()..changePage(0),
                  child: const DashboardSPGPage(),
                ),
              );

            case Routes.login:
              return CupertinoPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => LoginCubit(),
                  child: const LoginPage(),
                ),
              );

            case Routes.home:
              return CupertinoPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => HomeCubit()..initCubit(),
                  child: const HomePage(),
                ),
              );

            case Routes.homeSPG:
              return CupertinoPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => HomeSpgCubit()..initCubit(),
                  child: const HomeSpgPage(),
                ),
              );

            case Routes.requestSales:
              return CupertinoPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => HomeSpgCubit()..initCubit(),
                  child: const HomeSpgPage(),
                ),
              );

            case Routes.profileSales:
              return CupertinoPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ProfileSalesCubit()..initCubit(),
                  child: const ProfileSalesPage(),
                ),
              );

            case Routes.profileSPG:
              return CupertinoPageRoute(
                builder: (context) => BlocProvider<ProfileSPGCubit>(
                  create: (context) => ProfileSPGCubit()..initCubit(),
                  child: const ProfileSPGPage(),
                ),
              );

            case Routes.checkoutSales:
              final dynamic args = settings.arguments;
              Map<String, dynamic>? data = args;
              return CupertinoPageRoute(
                builder: (context) => BlocProvider<CheckOutSalesCubit>(
                  create: (context) => CheckOutSalesCubit(data)..initCubit(),
                  child: const CheckoutSalesMainPage(),
                ),
              );
            case Routes.orderOnly:
              final dynamic args = settings.arguments;
              Map<String, dynamic>? data = args;
              return CupertinoPageRoute(
                builder: (context) => BlocProvider<OrderOnlySalesCubit>(
                  create: (context) =>
                      OrderOnlySalesCubit(data)..initOrderOnly(),
                  child: const OrderOnlySalesPage(),
                ),
              );  
             
            default:
              return CupertinoPageRoute(
                builder: (context) => BlocProvider<SplashCubit>(
                  create: (context) => SplashCubit()..initCubit(),
                  child: const SplashPage(),
                ),
              );
          }
        },
      ),
    );
  }
}
