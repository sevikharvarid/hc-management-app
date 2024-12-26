import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/config/routes.dart';
import 'package:hc_management_app/features/order/cubit/order_only_cubit.dart';
import 'package:hc_management_app/features/order/cubit/order_only_state.dart';
import 'package:hc_management_app/features/order/ui/order_only_list_product_page.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/alert/custom_bottom_sheet.dart';
import 'package:hc_management_app/shared/widgets/alert/progress_dialog.dart';
import 'package:hc_management_app/shared/widgets/alert/toast_widget.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';
import 'package:hc_management_app/shared/widgets/text_field/custom_text_field.dart';

class OrderOnlySalesPage extends StatefulWidget {
  const OrderOnlySalesPage({super.key});

  @override
  State<OrderOnlySalesPage> createState() => _OrderOnlySalesPageState();
}

class _OrderOnlySalesPageState extends State<OrderOnlySalesPage> {
  final kodeBarang = TextEditingController();
  final namaBarang = TextEditingController();
  final jumlahBarang = TextEditingController();
  final hargaBarang = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderOnlySalesCubit>();
    return BlocConsumer<OrderOnlySalesCubit, OrderOnlySalesState>(
      listener: (context, state) {
        if (state is InputSOLoading) {
          showProgressDialog(context: context);
        }

        if (state is InputSOLoaded) {
          Navigator.pop(context);
        }

        if (state is InputAddingProductAlreadyExist) {
          Navigator.pop(context);
          showMessage(
            context: context,
            message: "Sudah ada barang yang sama",
            title: "Kesalahan Input Data",
          );
        }

        if (state is InputAddingProductFailed) {
          Navigator.pop(context);
          showMessage(
            context: context,
            message: "Harga barang melebihi batas",
            title: "Kesalahan Input Data",
          );
        }

        if (state is InputAddingProductLoading) {
          showProgressDialog(context: context);
        }

        if (state is InputAddingProductLoaded) {
          Navigator.pop(context);
          namaBarang.clear();
          kodeBarang.clear();
          jumlahBarang.clear();
          hargaBarang.clear();
        }

        if (state is SaveProductLoading) {
          showProgressDialog(context: context);
        }

        if (state is SaveProductLoaded) {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.mainSales, (route) => false);

          showToast(
            context: context,
            child: ToastWidget(
              borderColor: AppColors.green,
              backgroundColor: AppColors.green.withOpacity(0.2),
              message: "Save SO Berhasil",
              lineHeight: SizeUtils.baseLineText1,
              icon: 'assets/icons/ic_caution_blue.svg',
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: CustomButton(
            title: "Save SO",
            withIcon: false,
            active: cubit.dataTable!.isNotEmpty,
            margin: 20,
            action: () {
              if (cubit.dataTable!.isNotEmpty) {
                cubit.saveSOData();
              }
            },
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
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
                        offset: const Offset(
                            0, 2), // Perpindahan bayangan dari kontainer
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'No. SO : ${cubit.numberSO ?? '-'}',
                              style: GoogleFonts.nunito(
                                color: AppColors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              'No. Ref : ',
                              style: GoogleFonts.nunito(
                                color: AppColors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        spaceHeight(height: 16.h),
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      var result = await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  BlocProvider(
                                                    create: (context) =>
                                                        OrderOnlySalesCubit({})
                                                          ..initListProduct(),
                                                    child:
                                                        const OrderOnlyListProductPage(),
                                                  )));

                                      if (result != null) {
                                        String? value = result;
                                        log("value :$value");
                                        setState(() {
                                          namaBarang.text =
                                              value!.split(':').first;
                                          kodeBarang.text = value.split(':')[1];
                                          jumlahBarang.text = '1';
                                          hargaBarang.text =
                                              value.split(':')[2];
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 200.w,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: buildTextField(
                                        controller: kodeBarang,
                                        hintText: "Masukkan Kode Barang",
                                        label: "Kode Barang",
                                        isReadOnly: true,
                                        enabled: false,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 80.w,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: buildTextField(
                                      controller: jumlahBarang,
                                      keyboardType: TextInputType.number,
                                      hintText: "Jumlah",
                                      label: "QTY",
                                    ),
                                  ),
                                ],
                              ),
                              spaceHeight(height: 8.h),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      var result = await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  BlocProvider(
                                                    create: (context) =>
                                                        OrderOnlySalesCubit({})
                                                          ..initListProduct(),
                                                    child:
                                                        const OrderOnlyListProductPage(),
                                                  )));
                                      if (result != null) {
                                        String? value = result;
                                        setState(() {
                                          namaBarang.text =
                                              value!.split(':').first;
                                          kodeBarang.text = value.split(':')[1];
                                          jumlahBarang.text = '1';
                                          hargaBarang.text =
                                              value.split(':')[2];
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 200.w,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: buildTextField(
                                        controller: namaBarang,
                                        hintText: "Masukkan Nama Barang",
                                        label: "Nama Barang",
                                        isReadOnly: true,
                                        enabled: false,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 90.w,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: buildTextField(
                                      keyboardType: TextInputType.number,
                                      controller: hargaBarang,
                                      hintText: "Harga",
                                      label: "Harga Barang",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        CustomButton(
                          title: "Tambah Data",
                          withIcon: false,
                          active: true,
                          margin: 20,
                          action: () {
                            log("data :${cubit.dataTable}");
                            if (namaBarang.text.isEmpty &&
                                kodeBarang.text.isEmpty &&
                                jumlahBarang.text.isEmpty &&
                                hargaBarang.text.isEmpty) {
                              showMessage(
                                context: context,
                                message: "Lengkapi data barang terlebih dahulu",
                                title: "Data tidak lengkap",
                              );
                            } else {
                              cubit.addProducts(
                                namaBarang: namaBarang.text,
                                jumlahBarang: jumlahBarang.text,
                                hargaBarang: hargaBarang.text,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                spaceHeight(height: 12.h),
                if (cubit.dataTable!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 2, // Jarak blur bayangan
                          offset: const Offset(
                              0, 2), // Perpindahan bayangan dari kontainer
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 100,
                              child: Text(
                                "Item",
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            Container(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 35,
                              child: Text(
                                "Qty",
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            Container(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 75,
                              child: Text(
                                "HrgSat ",
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            Container(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 75,
                              child: Text(
                                "Harga",
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            Container(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 30.w,
                              // child: Text(
                              //   "Harga",
                              //   style: GoogleFonts.nunito(
                              //     fontWeight: FontWeight.bold,
                              //     color: AppColors.black,
                              //     fontSize: 12.sp,
                              //   ),
                              // ),
                            ),
                          ],
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children:
                              List.generate(cubit.dataTable!.length, (index) {
                            String? dataItem = cubit.dataTable![index];

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    dataItem.split(':')[0],
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 35,
                                  child: Text(
                                    dataItem.split(':')[1],
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 75,
                                  child: Text(
                                    dataItem.split(':')[2],
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 75,
                                  child: Text(
                                    dataItem.split(':')[3],
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cubit.removeItem(index);
                                  },
                                  child: SizedBox(
                                      width: 30.w,
                                      child: SvgPicture.asset(
                                          "assets/icons/ic_trash_red.svg")),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                if (cubit.dataTable!.isNotEmpty)
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          "Total : ${cubit.totalQuantity} Item",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          "Total Harga : Rp. ${cubit.totalPriceProduct}",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  showMessage({BuildContext? context, String? message, String? title}) {
    return CustomBottomSheet().showCustomBottomSheet(
      context: context!,
      title: title ?? "Terjadi Kesalahan Login!",
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
