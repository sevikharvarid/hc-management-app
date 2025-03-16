import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/config/routes.dart';
import 'package:hc_management_app/domain/model/stores.dart';
import 'package:hc_management_app/features/order/cubit/order_only_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/alert/custom_bottom_sheet.dart';
import 'package:hc_management_app/shared/widgets/alert/progress_dialog.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_loading.dart';
import 'package:hc_management_app/shared/widgets/dropdown/dropdown_with_search.dart';
import 'package:hc_management_app/shared/widgets/text_field/custom_text_field.dart';
import 'package:hc_management_app/shared/widgets/text_field/input_text_field_default.dart';

class OrderOnlyStorePage extends StatefulWidget {
  const OrderOnlyStorePage({super.key});

  @override
  State<OrderOnlyStorePage> createState() => _OrderOnlyStorePageState();
}

class _OrderOnlyStorePageState extends State<OrderOnlyStorePage> {
  TextEditingController namaToko = TextEditingController();
  TextEditingController nikSales = TextEditingController();
  TextEditingController noteSales = TextEditingController();
  TextEditingController storeController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  ScrollController scrollFilterController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderOnlyStoreCubit({})..initCubit(),
      child: BlocConsumer<OrderOnlyStoreCubit, OrderOnlyStoreState>(
        listener: (context, state) {
          if (state is OrderOnlyStoreLoading) {
            showProgressDialog(
              context: context,
            );
          }

          if (state is OrderOnlyStoreFailed) {
            Navigator.pop(context);
            showMessage(
                context: context, message: 'Pengajuan Order Only Anda Gagal');
          }

          if (state is OrderOnlyStoreSuccess) {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.orderOnlyInput,
              (route) => false,
              arguments: {
                'data': state.data,
              },
            );
          }

          if (state is OrderOnlyStoreLoaded) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final cubit = context.read<OrderOnlyStoreCubit>();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                "Order Only",
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
                  //   margin:
                  //       const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  //   child: buildTextField(
                  //     maxLines: 7,
                  //     controller: noteSales,
                  //     hintText: "Masukkan Keterangan",
                  //     label: "Notes",
                  //   ),
                  // ),
                  // Container(
                  //   margin: const EdgeInsets.only(
                  //     left: SizeUtils.basePaddingMargin24,
                  //     right: SizeUtils.basePaddingMargin24,
                  //     bottom: SizeUtils.basePaddingMargin16,
                  //     top: SizeUtils.basePaddingMargin10,
                  //   ),
                  //   child: ImagePickerWidget(
                  //     width: SizeUtils.baseWidthHeight100,
                  //     height: SizeUtils.baseWidthHeight100,
                  //     label: "Upload Gambar",
                  //     accessibilityId: "Ac",
                  //     quality: 15,
                  //     imageName: "Image Gambar",
                  //     mandatory: true,
                  //     minimumImage: 1,
                  //     maximumImage:
                  //         cubit.totalImage == 1 ? 1 : cubit.totalImage,
                  //     imagePickerType: cubit.totalImage == 1
                  //         ? ImagePickerTypeEnum.single
                  //         : ImagePickerTypeEnum.multiple,
                  //     pickedImage: const [],
                  //     onImageChanged: (value) {
                  //       cubit.saveImage(value);
                  //     },
                  //   ),
                  // ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: CustomButton(
                      borderColor: AppColors.primary,
                      backgroundColor: MaterialStateProperty.all(
                        AppColors.purple,
                      ),
                      title: "Input SO",
                      action: () async {
                        if (namaToko.text.isEmpty) {
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
    OrderOnlyStoreCubit cubit,
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
        return BlocProvider<OrderOnlyStoreCubit>(
          create: (context) => OrderOnlyStoreCubit({})..getStoreData(),
          child: BlocBuilder<OrderOnlyStoreCubit, OrderOnlyStoreState>(
            builder: (context, state) {
              var cubitDropdown = context.read<OrderOnlyStoreCubit>();

              List<DataStoreSales> listToko = [];

              listToko.addAll(cubitDropdown.listToko);

              return openDropdownMenuWithSearch(
                context: context,
                searchController: searchController,
                scrollController: scrollFilterController,
                searchHint: "Pilih Toko",
                emptyMessage: "Data kosong",
                bottomSheetTitle: "Pilih Toko",
                itemCount: (state is OrderOnlyStoreFilterLoading)
                    ? 5
                    : listToko.isNotEmpty
                        ? (listToko.length == 1)
                            ? 1
                            : listToko.length
                        : 0,
                itemBuilder: (BuildContext context, int index) {
                  if (state is OrderOnlyStoreFilterLoading) {
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
