import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/config/routes.dart';
import 'package:hc_management_app/domain/model/stores.dart';
import 'package:hc_management_app/features/check_in/cubit/check_in_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/alert/progress_dialog.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_loading.dart';
import 'package:hc_management_app/shared/widgets/dropdown/dropdown_with_search.dart';
import 'package:hc_management_app/shared/widgets/image/image_widget/image_picker/widget/image_picker_widget.dart';
import 'package:hc_management_app/shared/widgets/text_field/custom_text_field.dart';
import 'package:hc_management_app/shared/widgets/text_field/input_text_field_default.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  TextEditingController namaToko = TextEditingController();
  TextEditingController nikSales = TextEditingController();
  TextEditingController noteSales = TextEditingController();
  TextEditingController storeController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  ScrollController scrollFilterController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckInCubit(),
      child: BlocConsumer<CheckInCubit, CheckInState>(
        listener: (context, state) {
          if (state is CheckInLoading) {
            showProgressDialog(
              context: context,
              isDismissible: true,
            );
          }

          if (state is CheckInLoaded) {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.mainSales, (route) => false);
          }
        },
        builder: (context, state) {
          final cubit = context.read<CheckInCubit>();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                "Check In",
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
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(2),
              child: ListView(
                shrinkWrap: true,
                children: [
                  spaceHeight(
                    height: 12,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 16, top: 12, bottom: 12, right: 24),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 70,
                          width: 100,
                          child: Column(
                            children: [
                              Checkbox(
                                value: cubit.isChecked,
                                onChanged: (value) {
                                  cubit.setCheckBox(value);
                                },
                              ),
                              Text(
                                "Other Toko",
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: !cubit.isChecked,
                          child: Expanded(
                            child: DropdownWithSearchWidget(
                              width: MediaQuery.of(context).size.width,
                              height: SizeUtils.baseWidthHeight48,
                              searchController: storeController,
                              textHint: "Pilih Toko",
                              bottomSheetLabel: "Pilih Toko",
                              onTap: () {
                                showStoreList(context, cubit);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: buildTextField(
                      isReadOnly: !cubit.isReadOnlyStore,
                      controller: namaToko,
                      hintText: "Masukkan Nama Toko",
                      label: "Nama Toko",
                    ),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.only(
                  //       left: 16, top: 12, bottom: 12, right: 24),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         flex: 3,
                  //         child: Container(
                  //           padding: const EdgeInsets.only(
                  //               left: 8, top: 8, bottom: 8, right: 16),
                  //           child: CustomDropdownMenu(
                  //             labelText: "Pilihan Absen",
                  //             options: const [
                  //               "Kunjungan",
                  //               "Terima tagihan",
                  //               "Tukar faktur",
                  //             ],
                  //             onChanged: (String newValue) {
                  //               log('Selected option: $newValue');
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         flex: 2,
                  //         child: buildTextField(
                  //           controller: nikSales,
                  //           hintText: "Masukkan Nik",
                  //           label: "NIK",
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: buildTextField(
                      maxLines: 7,
                      controller: noteSales,
                      hintText: "Masukkan Keterangan",
                      label: "Notes",
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: SizeUtils.basePaddingMargin24,
                      right: SizeUtils.basePaddingMargin24,
                      bottom: SizeUtils.basePaddingMargin16,
                      top: SizeUtils.basePaddingMargin10,
                    ),
                    child: ImagePickerWidget(
                      width: SizeUtils.baseWidthHeight100,
                      height: SizeUtils.baseWidthHeight100,
                      label: "Upload Gambar",
                      accessibilityId: "Ac",
                      imageName: "Image Gambar",
                      mandatory: true,
                      minimumImage: 1,
                      maximumImage: 1,
                      imagePickerType: ImagePickerTypeEnum.single,
                      pickedImage: const [],
                      onImageChanged: (value) {
                        cubit.saveImage(value);
                      },
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: CustomButton(
                      borderColor: AppColors.primary,
                      backgroundColor: MaterialStateProperty.all(
                        AppColors.purple,
                      ),
                      title: "Kirim Data",
                      action: () async {
                        cubit.postData(
                          notes: noteSales.text,
                          storeName: namaToko.text,
                          storeCode: storeController.text,
                        );
                      
                      },
                      withIcon: false,
                      active: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> showStoreList(
    BuildContext context,
    CheckInCubit cubit,
  ) {
    // variable like initState() or initCubit
    // todo jump to value data

    // todo show dropdown
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      barrierColor: AppColors.grey600?.withOpacity(0.6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeUtils.baseRoundedCorner),
          topRight: Radius.circular(SizeUtils.baseRoundedCorner),
        ),
      ),
      builder: (context) {
        return BlocProvider<CheckInCubit>(
          create: (context) => CheckInCubit()..getStoreData(),
          child: BlocBuilder<CheckInCubit, CheckInState>(
            builder: (context, state) {
              var cubitDropdown = context.read<CheckInCubit>();

              List<DataStoreSales> listToko = [];

              listToko.addAll(cubitDropdown.listToko);

              return openDropdownMenuWithSearch(
                context: context,
                searchController: searchController,
                scrollController: scrollFilterController,
                searchHint: "Pilih Toko",
                emptyMessage: "Data kosong",
                bottomSheetTitle: "Pilih Toko",
                itemCount: (state is CheckInFilterLoading)
                    ? 5
                    : listToko.isNotEmpty
                        ? (listToko.length == 1)
                            ? 0
                            : listToko.length
                        : 0,
                itemBuilder: (BuildContext context, int index) {
                  if (state is CheckInFilterLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeUtils.basePaddingMargin10,
                        horizontal: SizeUtils.basePaddingMargin16,
                      ),
                      child: CustomLoading.defaultShape(
                        heightLoading: SizeUtils.baseWidthHeight12,
                      ),
                    );
                  }

                  var toko = listToko[index];
                  var fontWeight = FontWeight.w400;
                  var color = AppColors.transparent;

                  if (storeController.text == toko) {
                    fontWeight = FontWeight.w500;
                    color = AppColors.shadeBlue;
                  }

                  return InkWell(
                    highlightColor: AppColors.shadeBlue,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: SizeUtils.basePaddingMargin10,
                        horizontal: SizeUtils.basePaddingMargin16,
                      ),
                      color: color,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${toko.storeCode} - ${toko.storeName}",
                            style: GoogleFonts.nunito(
                              fontWeight: fontWeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      storeController.text = toko.storeCode;
                      namaToko.text = toko.storeName;
                      cubit.dataStore = toko;

                      searchController.clear();
                      Navigator.pop(context);
                      // cubit.validateInformationStep(
                      //   odometer: odometerController.text,
                      //   location: storeController.text,
                      // );
                    },
                  );
                },
                searchWidget: Container(
                  margin: const EdgeInsets.all(
                    SizeUtils.basePaddingMargin16,
                  ),
                  child: InputTextFieldDefault(
                    hint: "Cari Toko",
                    inputType: TextInputType.text,
                    height: SizeUtils.baseWidthHeight44,
                    hintFontSize: SizeUtils.baseWidthHeight14,
                    controller: searchController,
                    onChanged: (String value) {
                      // cubitDropdown.changeIconToClose(value);
                      // cubitDropdown.filterLocation(location: value);
                    },
                    onEditComplete: () {
                      FocusScope.of(context).unfocus();
                    },
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9./_, -]'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
