import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/features/check_out_sales/cubit/check_out_sales_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/widgets/alert/progress_dialog.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';

class ListProductPage extends StatefulWidget {
  const ListProductPage({super.key});

  @override
  State<ListProductPage> createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  String? value;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckOutSalesCubit>();
    return BlocConsumer<CheckOutSalesCubit, CheckOutSalesState>(
      listener: (context, state) {
        if (state is ListProductLoading) {
          showProgressDialog(context: context);
        }

        if (state is ListProductLoaded) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: Text(
              "List Barang",
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w400,
                color: AppColors.white,
                fontSize: 20,
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.white,
              ),
            ),
          ),
          body: Container(
            margin: const EdgeInsets.all(16),
            child: ListView.builder(
                itemCount: cubit.products!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context,
                          "${cubit.products![index].name}:${cubit.products![index].code}:${cubit.products![index].price}");
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 0.3,
                          ),
                        ],
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cubit.products![index].name,
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                                fontSize: 20.sp,
                              ),
                            ),
                            Text(
                              cubit.products![index].code,
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                                fontSize: 15.sp,
                              ),
                            ),
                            spaceHeight(height: 4.h),
                            Text(
                              "Harga Maksimal : Rp. ${cubit.products![index].price}",
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                                fontSize: 14.sp,
                              ),
                            ),
                          ]),
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}
