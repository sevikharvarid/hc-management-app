import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/features/history/bloc/history_spg_cubit.dart';
import 'package:hc_management_app/features/history/bloc/history_spg_state.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/alert/progress_dialog.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/card/attendance_card_item.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_widget.dart';
import 'package:hc_management_app/shared/widgets/date_field/input_date_field.dart';
import 'package:hc_management_app/shared/widgets/image/image_lottie.dart';
import 'package:hc_management_app/shared/widgets/text_field/custom_text_field.dart';
import 'package:intl/intl.dart';

class HistorySPGPage extends StatefulWidget {
  const HistorySPGPage({super.key});

  @override
  State<HistorySPGPage> createState() => _HistorySPGPageState();
}

class _HistorySPGPageState extends State<HistorySPGPage> {
 
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
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200, // Atur tinggi sesuai kebutuhan
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InputDateField(
                          margin: const EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          accessibilityId: "",
                          isDateRange: false,
                          controller: cubit.dateStart,
                          hint: "Tanggal awal",
                          label: "Tanggal Awal",
                          bottomSheetLabel: "Pilih tanggal",
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 1825)),
                          onSelected: (_) {
                            cubit.changeState();
                          },
                        ),
                        InputDateField(
                          isActive: cubit.stateDateEnd!,
                          margin: const EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          accessibilityId: "",
                          isDateRange: false,
                          controller: cubit.dateEnd,
                          hint: "Tanggal akhir",
                          label: "Tanggal Akhir",
                          bottomSheetLabel: "Pilih tanggal",
                          firstDate: cubit.dateStart.text.isNotEmpty
                              ? DateFormat('dd MMMM yyyy', 'id_ID')
                                  .parse(cubit.dateStart.text)
                              : DateTime.now(),
                          lastDate: cubit.dateStart.text.isNotEmpty
                              ? DateFormat('dd MMMM yyyy', 'id_ID')
                                  .parse(cubit.dateStart.text)
                                  .add(const Duration(days: 31))
                              : DateTime.now(),
                          onSelected: (_) {
                            cubit.saveMonth();
                          },
                        ),
                      ],
                    ),
                   
                    customHorizontalDivider(),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
                      child: buildTextField(
                        suffixIcon: const Icon(Icons.search),
                        controller: cubit.searchController,
                        label: "",
                        hintText: "Cari nama karyawan",
                        onFieldSubmitted: (value) {
                          cubit.findSPG(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: cubit.absenceList.isEmpty
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
                      :
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
                                onTap: () => showDetailImage(
                                      context: context,
                                      imageUrl:
                                          "http://103.140.34.220:280/storage/storage/${data.image}",
                                    ),
                            child: AttendanceCardItem(
                                  spgName: data.spgName,
                              attendanceDate:
                                  cubit.generalHelper.convertDateToString(
                                dateTime: cubit.absenceList[index].date,
                                dateFormat: "E, dd MMM yyyy",
                              ),
                              typeAbsence: data.type,
                              startDayTime: data.time,
                                  storeName: data.storeName,
                            ));
                      },
                        ),
                ),
              )
            ],
          ),
          // body: CustomScrollView(
          //   slivers: [
          //     SliverAppBar(
          //       backgroundColor: AppColors.white,
          //       elevation: 0,
          //       automaticallyImplyLeading: false,
          //       floating: true,
          //       pinned: true,
          //       centerTitle: false,
          //       leading: null,

          //       flexibleSpace: FlexibleSpaceBar(
          //         background: Container(
          //           height: 200,
          //           padding:
          //               const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          //           color: Colors.red,
          //           child: Column(
          //             children: [
          //               InputDateField(
          //                 margin: const EdgeInsets.symmetric(
          //                     vertical: 8, horizontal: 16),
          //                 accessibilityId: "",
          //                 controller: dateStart,
          //                 hint: "Pilih Tanggal",
          //                 label: "Tanggal Mulai",
          //                 bottomSheetLabel: "Pilih Tanggal",
          //                 isDateRange: false,
          //                 firstDate: DateTime.now(),
          //                 onSelected: (_) {
          //                   // if (bloc.startDate !=
          //                   //     bloc.generalHelper.convertStringToDate(
          //                   //         stringDate:
          //                   //             startDateEditingController.text)) {
          //                   //   endDateEditingController.clear();
          //                   // }
          //                   // bloc.validateForm(
          //                   //   startDateEditingController.text,
          //                   //   endDateEditingController.text,
          //                   //   reasonEditingController.text,
          //                   // );
          //                 },
          //               ),

          //               // Submission absence end date
          //               // InputDateField(
          //               //     margin: const EdgeInsets.symmetric(
          //               //         vertical: 8, horizontal: 16),
          //               //     accessibilityId: "",
          //               //     isDateRange: false,
          //               //     controller: dateEnd,
          //               //     hint: "Pilih tanggal",
          //               //     label: "Tanggal Akhir",
          //               //     bottomSheetLabel: "Pilih tanggal",
          //               //     firstDate: DateTime.now(),
          //               //     onSelected: (_) {
          //               //       // bloc.validateForm(
          //               //       //   startDateEditingController.text,
          //               //       //   endDateEditingController.text,
          //               //       //   reasonEditingController.text,
          //               //       // );
          //               //     }),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),

          //     SliverList(
          //       delegate: SliverChildListDelegate(
          //         [

          //           cubit.absenceList.isEmpty
          //               ? Column(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     const ImageLottie(
          //                       lottiePath: "assets/jsons/empty_data.json",
          //                       width: SizeUtils.baseWidthHeight214,
          //                       height: SizeUtils.baseWidthHeight214,
          //                     ),
          //                     Text(
          //                       "Data tidak di temukan",
          //                       style: GoogleFonts.nunito(
          //                         fontWeight: FontWeight.w400,
          //                         color: AppColors.black,
          //                         fontSize: 20,
          //                       ),
          //                     ),
          //                   ],
          //                 )
          //               :
          //           ListView.separated(
          //             padding: const EdgeInsets.only(top: 4, bottom: 20),
          //             physics: const NeverScrollableScrollPhysics(),
          //             shrinkWrap: true,
          //             itemCount: cubit.absenceList.length,
          //             separatorBuilder: (context, index) =>
          //                 const SizedBox(height: SizeUtils.basePaddingMargin2),
          //             itemBuilder: (context, index) {
          //               var data = cubit.absenceList[index];
          //               return GestureDetector(
          //                         onTap: () => showDetailImage(
          //                               context: context,
          //                               imageUrl:
          //                                   "http://103.140.34.220:280/storage/storage/${data.image}",
          //                             ),
          //                   child: AttendanceCardItem(
          //                           spgName: data.spgName,
          //                     attendanceDate:
          //                         cubit.generalHelper.convertDateToString(
          //                       dateTime: cubit.absenceList[index].date,
          //                       dateFormat: "E, dd MMM yyyy",
          //                     ),
          //                     typeAbsence: data.type,
          //                     startDayTime: data.time,
          //                           storeName: data.storeName,
          //                   ));
          //             },
          //           ),
          //         ],
          //       ),
          //     )
          //   ],
          // ),
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
