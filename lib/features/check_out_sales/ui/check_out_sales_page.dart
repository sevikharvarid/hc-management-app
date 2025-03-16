import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/config/routes.dart';
import 'package:hc_management_app/features/check_out_sales/cubit/check_out_sales_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/alert/custom_bottom_sheet.dart';
import 'package:hc_management_app/shared/widgets/alert/progress_dialog.dart';
import 'package:hc_management_app/shared/widgets/alert/toast_widget.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_widget.dart';
import 'package:hc_management_app/shared/widgets/dropdown/dropdown_with_search.dart';
import 'package:hc_management_app/shared/widgets/image/image_network_rectangle.dart';
import 'package:location/location.dart';

class CheckOutSalesPage extends StatefulWidget {
  const CheckOutSalesPage({super.key});

  @override
  State<CheckOutSalesPage> createState() => _CheckOutSalesPageState();
}

class _CheckOutSalesPageState extends State<CheckOutSalesPage> {
  final Location _location = Location();

  Future<bool> checkMockLocation() async {
    try {
      // Cek apakah izin lokasi sudah diberikan
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          return false; // Tidak bisa akses layanan lokasi
        }
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return false; // Tidak memiliki izin lokasi
        }
      }

      // Dapatkan informasi lokasi dan cek apakah mock
      LocationData locationData = await _location.getLocation();
      return locationData.isMock ?? false; // Kembalikan true jika lokasi mock
    } catch (e) {
      log("Error: $e");
      return false; // Return false jika terjadi error
    }
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<CheckOutSalesCubit>();
    return BlocConsumer<CheckOutSalesCubit, CheckOutSalesState>(
      listener: (context, state) {
        if (state is CheckOutSalesLoading) {
          showProgressDialog(context: context);
        }

        if (state is CheckOutSalesCheckoutFailed) {
          Navigator.pop(context);
          showMessage(context, 'Pengajuan Check Out Anda Gagal');
        }

        if (state is CheckOutSalesCheckoutSuccess) {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.mainSales, (route) => false);

          showToast(
            context: context,
            child: ToastWidget(
              borderColor: AppColors.green,
              backgroundColor: AppColors.green.withOpacity(0.2),
              message: "Pengajuan Check Out Berhasil",
              lineHeight: SizeUtils.baseLineText1,
              icon: 'assets/icons/ic_caution_blue.svg',
            ),
          );
        }

        if (state is CheckOutSalesLoaded) {
          Navigator.pop(context);
          // Navigator.pushNamedAndRemoveUntil(
          //     context, Routes.mainSales, (route) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey
                      .withOpacity(0.3), // Warna bayangan (shadow color)
                  spreadRadius: 2, // Jarak penyebaran bayangan
                  blurRadius: 2, // Jarak blur bayangan
                  offset:
                      const Offset(0, 2), // Perpindahan bayangan dari kontainer
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tgl In : ${cubit.inDate ?? '-'}',
                        style: GoogleFonts.nunito(
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        'Tgl Out : ${cubit.outDate ?? '-'}',
                        style: GoogleFonts.nunito(
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 24.h),
                    alignment: Alignment.center,
                    child: cubit.checkInImage != null
                        ? ImageNetworkRectangle(
                            width: SizeUtils.baseWidthHeight240,
                            height: SizeUtils.baseWidthHeight240,
                            imageUrl:
                                "https://visit.sanwin.my.id/storage/storage/${cubit.checkInImage}",
                            boxFit: BoxFit.cover,
                          )
                        : Center(
                            child: loadingProgress(),
                          ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.blue70,
                            size: 65,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Jam Masuk",
                                style: GoogleFonts.nunito(
                                  color: AppColors.black,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                cubit.inTime ?? "-",
                                style: GoogleFonts.nunito(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      spaceWidth(width: SizeUtils.basePaddingMargin10),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.redButton,
                            size: 65,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Jam Keluar",
                                style: GoogleFonts.nunito(
                                  color: AppColors.black,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                cubit.outTime ?? "-",
                                style: GoogleFonts.nunito(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  spaceHeight(height: 4.h),
                  customHorizontalDivider(),
                  spaceHeight(height: 4.h),
                  if ((cubit.origin != null) || cubit.destination != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: AppColors.blue70,
                              size: 25,
                            ),
                            Expanded(
                              child: Text(
                                cubit.origin ?? '-',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                  color: AppColors.black,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        spaceHeight(height: 4.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: AppColors.redButton,
                              size: 25,
                            ),
                            Expanded(
                              child: Text(
                                cubit.destination ?? '-',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: GoogleFonts.nunito(
                                  color: AppColors.black,
                                  fontSize: 14.sp,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  if (cubit.outTime == null)
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 12.h),
                      child: CustomButton(
                        borderColor: AppColors.primary,
                        backgroundColor: MaterialStateProperty.all(
                          AppColors.purple,
                        ),
                        title: "Checkout",
                        action: () async {
                          bool isMockLocation = await checkMockLocation();
                          if (isMockLocation) {
                            showMessage(
                              context,
                              "Gunakan lokasi yang sesuai dengan Device anda",
                            );
                          } else {
                            cubit.postCheckoutCubit();
                          }
                        },
                        withIcon: false,
                        active: true,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  showMessage(BuildContext context, String? message) {
    return CustomBottomSheet().showCustomBottomSheet(
      context: context,
      title: "Submit Check Out Gagal",
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
