import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hc_management_app/config/routes.dart';
import 'package:hc_management_app/features/splash/cubit/splash_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthenticated) {
          if (state.userType == 'sales') {
            Navigator.pushReplacementNamed(context, Routes.mainSales);
          }

          if (state.userType == 'spg') {
            Navigator.pushReplacementNamed(context, Routes.mainSPG);
          }
        }

        if (state is SplashUnauthenticated) {
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(),
        );
      },
    );
  }
}
