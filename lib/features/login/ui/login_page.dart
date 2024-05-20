import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/config/routes.dart';
import 'package:hc_management_app/features/login/cubit/login_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/alert/custom_bottom_sheet.dart';
import 'package:hc_management_app/shared/widgets/alert/progress_dialog.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';
import 'package:hc_management_app/shared/widgets/text_field/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? nik = TextEditingController();
  TextEditingController? password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          showProgressDialog(
            context: context,
            isDismissible: true,
          );
        }

        if (state is LoginLoaded) {
          Navigator.pop(context);
        }

        if (state is LoginSuccessSalesDashboard) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, Routes.mainSales);
        }

        if (state is LoginSuccessSPGDashboard) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, Routes.mainSPG);
        }

        if (state is LoginFailed) {
          Navigator.pop(context);
        }

        if (state is LoginError) {
          Navigator.pop(context);
          showMessage(context, state.message ?? 'Login Error');
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.zero,
                  child: Image.asset(
                    // "assets/images/splash_screen_background.png",
                    "assets/images/login_background.png",
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  children: [
                    spaceHeight(
                      height: 20,
                    ),
                    Image.asset(
                      "assets/images/ic_launcher_round.png",
                      width: 300,
                      height: 300,
                    ),
                    spaceHeight(
                      height: 45.h,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: SizeUtils.basePaddingMargin24),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Welcome To\nS7win App",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.nunito(
                            fontSize: 22,
                            color: AppColors.black80,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: SizeUtils.basePaddingMargin24),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Login",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.nunito(
                            fontSize: 22,
                            color: AppColors.black80,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    spaceHeight(height: 40.h),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: buildTextField(
                        controller: nik,
                        hintText: "Masukkan NIK",
                        label: "NIK",
                      ),
                    ),
                    spaceHeight(
                      height: 10.h,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: buildTextField(
                        controller: password,
                        hintText: "Masukkan Password",
                        label: "Password",
                        suffixIcon: IconButton(
                          onPressed: () => cubit.setVisibile(),
                          icon: Icon(
                            cubit.isVisible!
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        obscureText: !cubit.isVisible!,
                      ),
                    ),
                    spaceHeight(
                      height: 20.h,
                    ),
                    CustomButton(
                      title: "Login",
                      withIcon: false,
                      active: true,
                      margin: 20,
                      action: () async {
                        if (password!.text.length < 8) {
                          showMessage(context, "Password minimal 8 Karakter");
                        } else {
                          cubit.postLogin(
                            nik: nik!.text,
                            password: password!.text,
                          );
                        }
                      },
                    ),
                  ],
                ),
                
              ],
            ),
          ),
        );
      },
    );
  }

  showMessage(BuildContext context, String? message) {
    return CustomBottomSheet().showCustomBottomSheet(
      context: context,
      title: "Terjadi Kesalahan Login!",
      titleIcon: "assets/icons/ic_caution_red.svg",
      bodyContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          spaceHeight(
            height: 15,
          ),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: AppColors.black80,
              fontWeight: FontWeight.w400,
            ),
          ),
          spaceHeight(
            height: 15,
          ),
        ],
      ),
      bottomContent: Container(
          padding: const EdgeInsets.all(SizeUtils.basePaddingMargin16),
          child: CustomButton(
            title: "Coba Lagi",
            action: () => Navigator.pop(context),
            withIcon: false,
            active: true,
          )),
    );
  }
}
