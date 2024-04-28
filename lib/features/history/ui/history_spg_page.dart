import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/features/history/bloc/history_spg_cubit.dart';
import 'package:hc_management_app/features/history/bloc/history_spg_state.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/alert/custom_bottom_sheet.dart';
import 'package:hc_management_app/shared/widgets/alert/progress_dialog.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/card/attendance_card_item.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/input_month_filter.dart';

class HistorySPGPage extends StatefulWidget {
  const HistorySPGPage({super.key});

  @override
  State<HistorySPGPage> createState() => _HistorySPGPageState();
}

class _HistorySPGPageState extends State<HistorySPGPage> {
  TextEditingController requestTypeController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HistorySPGCubit>();
    return BlocConsumer<HistorySPGCubit, HistorySPGState>(
      listener: (context, state) {
        if (state is HistorySPGLoading) {
          showProgressDialog(context: context);
        }

        if (state is HistorySPGLoaded) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              "History",
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
                        onSelected: (value) {},
                      ),
                      spaceWidth(width: 8),
                      GestureDetector(
                          onTap: () {
                            CustomBottomSheet().openRequestTypePicker(
                              context,
                              "Request Type",
                              requestTypeController,
                              ["Awaiting", "Pending", "Cancelled", "Approved"],
                            ).then((value) {});
                          },
                          child: cardFilter(
                              title: "Request Type", isDropdown: true)),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ListView.separated(
                      padding: const EdgeInsets.only(top: 4, bottom: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cubit.absenceList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: SizeUtils.basePaddingMargin2),
                      itemBuilder: (context, index) {
                        var data = cubit.absenceList[index];
                        return GestureDetector(
                            onTap: () {},
                            child: AttendanceCardItem(
                              attendanceDate:
                                  cubit.generalHelper.convertDateToString(
                                dateTime: cubit.absenceList[index].date,
                                dateFormat: "E, dd MMM yyyy",
                              ),
                              typeAbsence: data.type,
                              startDayTime: data.time,
                              endDayTime: data.storeName,
                            ));
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
