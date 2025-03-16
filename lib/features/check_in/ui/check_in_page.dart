import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/config/routes.dart';
import 'package:hc_management_app/domain/model/stores.dart';
import 'package:hc_management_app/features/check_in/cubit/check_in_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/alert/custom_bottom_sheet.dart';
import 'package:hc_management_app/shared/widgets/alert/progress_dialog.dart';
import 'package:hc_management_app/shared/widgets/alert/toast_widget.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_loading.dart';
import 'package:hc_management_app/shared/widgets/dropdown/dropdown_with_search.dart';
import 'package:hc_management_app/shared/widgets/image/image_widget/image_picker/widget/image_picker_widget.dart';
import 'package:hc_management_app/shared/widgets/text_field/custom_text_field.dart';
import 'package:hc_management_app/shared/widgets/text_field/input_text_field_default.dart';
import 'package:location/location.dart';

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

  final Location _location = Location();
  String? storeName = '';

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
    return BlocProvider(
      create: (context) => CheckInCubit()..initCubit(),
      child: BlocConsumer<CheckInCubit, CheckInState>(
        listener: (context, state) {
          if (state is CheckInLoading) {
            showProgressDialog(
              context: context,
            );
          }

          if (state is CheckInFailed) {
            Navigator.pop(context);
            showMessage(
                context: context, message: 'Pengajuan Check In Anda Gagal');
          }

          if (state is CheckInSuccess) {
            Navigator.pop(context);

            showToast(
              context: context,
              child: ToastWidget(
                borderColor: AppColors.green,
                backgroundColor: AppColors.green.withOpacity(0.2),
                message: "Pengajuan Check In Berhasil",
                lineHeight: SizeUtils.baseLineText1,
                icon: 'assets/icons/ic_caution_blue.svg',
              ),
            );
          }

          if (state is CheckInSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.mainSales, (route) => false);
          }

          if (state is CheckInLoaded) {
            Navigator.pop(context);
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
                      userName: cubit.userName,
                      storeName: storeName,
                      notes: cubit.notes,
                      width: SizeUtils.baseWidthHeight100,
                      height: SizeUtils.baseWidthHeight100,
                      label: "Upload Gambar",
                      accessibilityId: "Ac",
                      quality: 15,
                      imageName: "Image Gambar",
                      mandatory: true,
                      minimumImage: 1,
                      maximumImage:
                          cubit.totalImage == 1 ? 1 : cubit.totalImage,
                      imagePickerType: cubit.totalImage == 1
                          ? ImagePickerTypeEnum.single
                          : ImagePickerTypeEnum.multiple,
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
                        bool isMockLocation = await checkMockLocation();
                        if (isMockLocation) {
                          showMessage(
                            context: context,
                            title: "Terjadi Kesalahan",
                            message:
                                "Gunakan lokasi yang sesuai dengan Device anda",
                          );
                        } else {
                          if (namaToko.text.isEmpty &&
                              cubit.imagePath == null) {
                            showMessage(
                              context: context,
                              title: "Terjadi Kesalahan",
                              message: "Harap lengkapi form terlebih dahulu",
                            );
                          } else {
                            cubit.postData(
                              notes: noteSales.text,
                              storeName: namaToko.text,
                              storeCode: storeController.text,
                            );
                          }
                        }
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

  showMessage(
      {BuildContext? context,
      String? title = "Submit Check In Gagal",
      String? message}) {
    return CustomBottomSheet().showCustomBottomSheet(
      context: context!,
      title: title,
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
                            ? 1
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
                      debugPrint("store name ini : ${namaToko.text}");
                      setState(() {
                        storeName = namaToko.text;
                      });

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
                      debugPrint("value is : $value");
                      // cubitDropdown.changeIconToClose(value);
                      cubitDropdown.filterLocation(value: value);
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
