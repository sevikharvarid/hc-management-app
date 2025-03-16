import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/config/routes.dart';
import 'package:hc_management_app/domain/model/visits.dart';
import 'package:hc_management_app/features/request/request_sales/cubit/request_sales_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/alert/progress_dialog.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/card/visit_cart_item.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/input_month_filter.dart';
import 'package:hc_management_app/shared/widgets/image/image_lottie.dart';

class RequestSalesPage extends StatefulWidget {
  const RequestSalesPage({super.key});

  @override
  State<RequestSalesPage> createState() => _RequestSalesPageState();
}

class _RequestSalesPageState extends State<RequestSalesPage> {
  TextEditingController requestTypeController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<RequestSalesCubit>();
    return BlocConsumer<RequestSalesCubit, RequestSalesState>(
      listener: (context, state) {
        if (state is RequestSalesLoading) {
          showProgressDialog(context: context);
        }

        if (state is RequestSalesLoaded) {
          Navigator.pop(context);
        }

        if (state is RequestSalesSuccessGet) {}
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              "Request",
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w400,
                color: AppColors.white,
                fontSize: 20,
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.white,
                elevation: 0,
                automaticallyImplyLeading: false,
                floating: true,
                pinned: true,
                centerTitle: false,
                leading: null,
                title: Container(
                  height: kToolbarHeight,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      // GestureDetector(
                      //     onTap: () {},
                      //     child: cardFilter(title: "Filter", filterType: true)),
                      InputMonthField(
                        bottomSheetLabel: "Pilih Tanggal",
                        controller: monthController,
                        onSelected: (value) {
                          cubit.selectMonth(
                            month: monthController.text,
                          );
                        },
                      ),
                      spaceWidth(width: 8),
                      // GestureDetector(
                      //     onTap: () {
                      //       CustomBottomSheet().openRequestTypePicker(
                      //         context,
                      //         "Request Type",
                      //         requestTypeController,
                      //         ["Awaiting", "Pending", "Cancelled", "Approved"],
                      //       ).then((value) {});
                      //     },
                      //     child: cardFilter(
                      //         title: "Request Type", isDropdown: true)),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    cubit.visits.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const ImageLottie(
                                lottiePath: "assets/jsons/empty_data.json",
                                width: SizeUtils.baseWidthHeight214,
                                height: SizeUtils.baseWidthHeight214,
                              ),
                              Text(
                                "Data tidak di temukan",
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(top: 4, bottom: 20),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cubit.visits.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                    height: SizeUtils.basePaddingMargin2),
                            itemBuilder: (context, index) {
                              var data = cubit.visits[index];
                              return GestureDetector(
                                onTap: () => onPressedCardList(cubit, data),
                                child: VisitCardItem(
                                  attendanceDateIn: data.inDate != null
                                      ? cubit.generalHelper.convertDateToString(
                                          dateFormat: "EEEE, dd MMMM yyyy",
                                          dateTime:
                                              DateTime.parse(data.inDate!),
                                        )
                                      : '-',
                                  attendanceDateOut: data.outDate != null
                                      ? cubit.generalHelper.convertDateToString(
                                          dateFormat: "EEEE, dd MMMM yyyy",
                                          dateTime:
                                              DateTime.parse(data.outDate!),
                                        )
                                      : '-',
                                  startDateTime: data.inTime,
                                  endDateTime: data.outTime ?? '-',
                                  storeName: data.storeName ?? '-',
                                  storeCode: data.storeCode ?? '-',
                                  soNumber: "S0XXXXX9",
                                ),
                              );
                            },
                          ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void onPressedCardList(RequestSalesCubit cubit, VisitData? data) async {
    bool gpsStatus = await cubit.checkAndTurnOnGPS();

    if (gpsStatus) {
      // jika
      if (data!.image!.contains("order_only") ||
          data.inLat == 'order_only' ||
          data.inLong == 'order_only') {
        Navigator.pushNamed(
          context,
          Routes.orderOnly,
          arguments: {
            'data': data,
            'isFromHome': false,
          },
        );
      } else {
        Navigator.pushNamed(
          context,
          Routes.checkoutSales,
          arguments: {
            'data': data,
            'isFromHome': false,
          },
        );
      }
    } else {
      onPressedCardList(cubit, data);
    }
  }

  Widget cardFilter({
    bool? filterType = false,
    bool? isDropdown = false,
    String? title,
  }) {
    if (filterType!) {
      return Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: AppColors.black40)),
        child: Center(
          child: Row(
            children: [
              Icon(
                Icons.filter_list_alt,
                size: 15,
                color: AppColors.black,
              ),
              spaceWidth(
                width: 4,
              ),
              Text(
                title!,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (isDropdown!) {
      return Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: AppColors.black40)),
        child: Center(
          child: Row(
            children: [
              Text(
                title!,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.black,
                ),
              ),
              spaceWidth(
                width: 4,
              ),
              Icon(
                Icons.arrow_drop_down_outlined,
                size: 25,
                color: AppColors.black,
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: AppColors.black40)),
      child: Center(
        child: Text(
          title!,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
