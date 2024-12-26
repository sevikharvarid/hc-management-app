import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/config/routes.dart';
import 'package:hc_management_app/features/profile/profile_spg/cubit/profile_spg_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/alert/custom_bottom_sheet.dart';
import 'package:hc_management_app/shared/widgets/alert/progress_dialog.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';
import 'package:hc_management_app/shared/widgets/card/custom_card_item.dart';
import 'package:hc_management_app/shared/widgets/image/image_network_rectangle.dart';

class ProfileSPGPage extends StatefulWidget {
  const ProfileSPGPage({super.key});

  @override
  State<ProfileSPGPage> createState() => _ProfileSPGPageState();
}

class _ProfileSPGPageState extends State<ProfileSPGPage> {
  final password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileSPGCubit>();
    return BlocConsumer<ProfileSPGCubit, ProfileSPGState>(
      listener: (context, state) {
        if (state is ProfileSPGLogout) {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.landing, (route) => false);
        }

        if (state is ProfileSPGLoading) {
          showProgressDialog(context: context);
        }

        if (state is ProfileSPGLoaded) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is ProfileSPGLoading) {
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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Ganti dengan warna yang diinginkan
                  ),
                  child: cubit.photoProfile != null
                      ? ClipOval(
                          child: ImageNetworkRectangle(
                            width: SizeUtils.baseWidthHeight110,
                            height: SizeUtils.baseWidthHeight110,
                            imageUrl:
                                "https://visit.sanwin.my.id/storage/storage/${cubit.photoProfile}",
                            boxFit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: AppColors.black,
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
                        title: cubit.nik!,
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
                    if (cubit.logoutStatus == 1)
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 2.h),
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
                            //       create: (context) => ProfileSPGCubit(),
                            //       child: BlocBuilder<ProfileSPGCubit,
                            //           ProfileSPGState>(
                            //         builder: (context, state) {
                            //           final cubitDialog =
                            //               context.read<ProfileSPGCubit>();
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
    final cubit = context.read<ProfileSPGCubit>();
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
