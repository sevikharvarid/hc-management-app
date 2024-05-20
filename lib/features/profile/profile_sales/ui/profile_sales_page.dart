import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/config/routes.dart';
import 'package:hc_management_app/features/profile/profile_sales/cubit/profile_sales_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/alert/custom_bottom_sheet.dart';
import 'package:hc_management_app/shared/widgets/alert/progress_dialog.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';
import 'package:hc_management_app/shared/widgets/card/custom_card_item.dart';
import 'package:hc_management_app/shared/widgets/image/image_network_rectangle.dart';

class ProfileSalesPage extends StatefulWidget {
  const ProfileSalesPage({super.key});

  @override
  State<ProfileSalesPage> createState() => _ProfileSalesPageState();
}

class _ProfileSalesPageState extends State<ProfileSalesPage> {
  final password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileSalesCubit>();
    return BlocConsumer<ProfileSalesCubit, ProfileSalesState>(
      listener: (context, state) {
        if (state is ProfileSalesLogout) {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.landing, (route) => false);
        }

        if (state is ProfileSalesLoading) {
          showProgressDialog(context: context);
        }

        if (state is ProfileSalesLoaded) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is ProfileSalesLoading) {
          return Container();
        }
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            title: Text(
              "Profile",
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w400,
                color: AppColors.white,
                fontSize: 20,
              ),
            ),
          ),
          body: Container(
            color: Colors.white54,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  width: 120.0, // Sesuaikan ukuran diameter lingkaran
                  height: 120.0, // Sesuaikan ukuran diameter lingkaran
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        AppColors.grey200, // Ganti dengan warna yang diinginkan
                  ),
                  child: cubit.photoProfile != null
                      ? ClipOval(
                          child: ImageNetworkRectangle(
                            width: SizeUtils.baseWidthHeight110,
                            height: SizeUtils.baseWidthHeight110,
                            imageUrl:
                                "http://103.140.34.220:280/storage/storage/${cubit.photoProfile}",
                            boxFit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: AppColors.black,
                          size: 70,
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cubit.name ?? '',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.nunito(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black80,
                      ),
                    ),
                  ],
                ),
               
                const SizedBox(
                  height: 35,
                ),
                Expanded(
                    child: ListView(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                      child: CustomCardItem(
                        withIcon: false,
                        widgetIcon: const Icon(Icons.person),
                        title: cubit.nik ?? '',
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                      child: CustomCardItem(
                        withIcon: false,
                        widgetIcon: const Icon(Icons.note),
                        title: cubit.notes ?? '',
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                      child: CustomCardItem(
                        widgetIcon: const Icon(Icons.exit_to_app),
                        title: 'Logout',
                        onTap: () {
                          showMessage(context, "Anda yakin ingin logout ?");
                          // showDialog(
                          //   barrierDismissible: false,
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return BlocProvider(
                          //       create: (context) => ProfileSalesCubit(),
                          //       child: BlocBuilder<ProfileSalesCubit,
                          //           ProfileSalesState>(
                          //         builder: (context, state) {
                          //           final cubitDialog =
                          //               context.read<ProfileSalesCubit>();
                          //           return Form(
                          //             key: _formKey,
                          //             child: AlertDialog(
                          //               title: const Text('Ubah password'),
                          //               content: buildTextField(
                          //                 controller: password,
                          //                 hintText: "Masukkan Password",
                          //                 label: "Password",
                          //                 suffixIcon: IconButton(
                          //                   onPressed: () =>
                          //                       cubitDialog.setVisibile(),
                          //                   icon: Icon(
                          //                     cubitDialog.isVisible!
                          //                         ? Icons.visibility_off
                          //                         : Icons.visibility,
                          //                   ),
                          //                 ),
                          //                 obscureText: !cubitDialog.isVisible!,
                          //                 validator: (value) {
                          //                   if (value!.length < 8) {
                          //                     return "Password harus lebih dari 8 karakter";
                          //                   }
                          //                   return null;
                          //                 },
                          //               ),
                          //               actions: <Widget>[
                          //                 TextButton(
                          //                   onPressed: () {
                          //                     if (password.text.isNotEmpty) {
                          //                       if (_formKey.currentState!
                          //                           .validate()) {
                          //                         Navigator.of(context).pop();

                          //                         password.clear();
                          //                       }
                          //                     } else {
                          //                       Navigator.of(context).pop();
                          //                     }
                          //                   },
                          //                   child: Text(
                          //                     "Tutup",
                          //                     textAlign: TextAlign.center,
                          //                     style: GoogleFonts.nunito(
                          //                       fontSize: 14,
                          //                       color: AppColors.black80,
                          //                       fontWeight: FontWeight.w400,
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           );
                          //         },
                          //       ),
                          //     );
                          //   },
                          // );
                          // showMessage(
                          // context, "Silahkan logout terlebih dahulu");
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ))
              ],
            ),
          ),
        );
      },
    );
  }

  showMessage(BuildContext context, String? message) {
    final cubit = context.read<ProfileSalesCubit>();
    return CustomBottomSheet().showCustomBottomSheet(
      context: context,
      title: "Logout",
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
      bottomContent: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: CustomButton(
              buttonWidth: MediaQuery.of(context).size.width / 2.5,
              title: "Ya, Saya yakin",
              action: () => cubit.logout(),
              // action: () => Navigator.pop(context),
              withIcon: false,
              active: true,
              textColor: AppColors.redText,
              borderColor: AppColors.redButton,
              backgroundColor: MaterialStateProperty.all(
                AppColors.white,
              ),
            ),
          ),
          spaceWidth(width: 16),
          Container(
            child: CustomButton(
              buttonWidth: MediaQuery.of(context).size.width / 2.5,
              title: "Batalkan",
              action: () => Navigator.pop(context),
              withIcon: false,
              active: true,
            ),
          ),
        ],
      ),
    );
  }
}
