import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/domain/model/list_spg.dart';
import 'package:hc_management_app/features/face_recognition/ui/face_recognition_page.dart';
import 'package:hc_management_app/features/homespg/cubit/home_spg_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/utils/preferences/preferences.dart';
import 'package:hc_management_app/shared/widgets/alert/custom_bottom_sheet.dart';
import 'package:hc_management_app/shared/widgets/alert/progress_dialog.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_loading.dart';
import 'package:hc_management_app/shared/widgets/dropdown/dropdown_with_search.dart';
import 'package:hc_management_app/shared/widgets/image/image_network_rectangle.dart';
import 'package:hc_management_app/shared/widgets/text_field/input_text_field_default.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeSpgPage extends StatefulWidget {
  const HomeSpgPage({super.key});

  @override
  State<HomeSpgPage> createState() => _HomeSpgPageState();
}



class _HomeSpgPageState extends State<HomeSpgPage> {
  
  TextEditingController nameController = TextEditingController();

  TextEditingController searchController = TextEditingController();
  ScrollController scrollFilterController = ScrollController();
  Preferences preferences = Preferences();

  late StreamController<DateTime> _dateTimeController;
  late Stream<DateTime> _dateTimeStream;
  late Timer _timeUpdater;

  @override
  void initState() {
    super.initState();
    _dateTimeController = StreamController<DateTime>();
    _dateTimeStream = _dateTimeController.stream;
    _startUpdatingTime();
  }

  void _startUpdatingTime() {
    _timeUpdater = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_dateTimeController.isClosed) {
        _dateTimeController.add(DateTime.now());
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeSpgCubit>();
    return BlocConsumer<HomeSpgCubit, HomeSpgState>(
      listener: (context, state) {
        if (state is HomeSpgLoading) {
          showProgressDialog(context: context);
        }

        if (state is HomeSpgLoaded) {
          Navigator.pop(context);
        }

        if (state is HomeSpgImageSaved) {
          Navigator.pop(context);
        }

        if (state is HomeSpgSuccessLoaded) {
          Navigator.pop(context);
          cubit.checkGPS();
        }

        if (state is HomeSpgSuccess) {
          Navigator.pop(context);
          showSubmitMessage(
            context,
            "Submit Berhasil",
            state.message,
          );
        }

        if (state is HomeSpgFailed) {
          Navigator.pop(context);
          showSubmitMessage(
            context,
            "Submit Gagal!",
            state.message,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.primary.withOpacity(0.4),
                  AppColors.primary20.withOpacity(0.4),
                  AppColors.primary20.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              shape: BoxShape.circle,
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              onPressed: () => onPressedCamera(cubit),
              tooltip: 'Increment',
              elevation: 2.0,
              child: const Icon(
                Icons.photo_camera_sharp,
                size: 30,
              ),
            ),
          ),
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.2,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
              ),
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    floating: true,
                    pinned: true,
                    snap: false,
                    centerTitle: false,
                    leading: null,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello,",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          cubit.nameSPG ?? "NoName",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,

                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      Row(
                        children: [
                          Container(
                            width: 40.0, // Sesuaikan ukuran diameter lingkaran
                            height: 40.0, // Sesuaikan ukuran diameter lingkaran
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors
                                  .white, // Ganti dengan warna yang diinginkan
                            ),
                            child: cubit.photoProfile != null
                                ? ClipOval(
                                    child: ImageNetworkRectangle(
                                      width: SizeUtils.baseWidthHeight110,
                                      height: SizeUtils.baseWidthHeight110,
                                      imageUrl:
                                          "http://103.140.34.220:280/storage/storage/${cubit.photoProfile}",
                                      boxFit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    color: AppColors.black,
                                  ),
                          ),
                          const SizedBox(
                            width: 16,
                          )
                        ],
                      )
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        spaceHeight(height: 20),
                        header(cubit),
                        spaceHeight(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          child: Text(
                            cubit.namaToko!,
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 16),
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 35),
                          height: 130,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(
                                    0.4), // Warna bayangan (shadow color)
                                spreadRadius: 3, // Jarak penyebaran bayangan
                                blurRadius: 4, // Jarak blur bayangan
                                offset: const Offset(0,
                                    3), // Perpindahan bayangan dari kontainer
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_add_alt_1,
                                color: AppColors.orange,
                                size: 40,
                              ),
                              spaceWidth(
                                width: SizeUtils.basePaddingMargin10,
                              ),
                              Expanded(
                                child: DropdownWithSearchWidget(
                                  width: MediaQuery.of(context).size.width,
                                  height: SizeUtils.baseWidthHeight48,
                                  searchController: nameController,
                                  textHint: "Pilih Nama",
                                  bottomSheetLabel: "Pilih Nama",
                                  onTap: () => onPressedListName(cubit),
                                ),
                              ),
                            ],
                          ),
                        ),
                        spaceHeight(height: SizeUtils.basePaddingMargin8),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          height: 400,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 3,
                                blurRadius: 4,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: cubit.imagePath != null
                              ? Image.file(
                                  File(
                                    cubit.imagePath!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : const Center(
                                  child: Text(
                                    'No Image Selected',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void onPressedListName(HomeSpgCubit cubit) async {
    bool gpsStatus = await cubit.checkAndTurnOnGPS();

    if (gpsStatus) {
      showStoreList(cubit);
    } else {
      onPressedListName(cubit);
    }
  }

  void onPressedCamera(HomeSpgCubit cubit) async {
    bool gpsStatus = await cubit.checkAndTurnOnGPS();

    if (gpsStatus) {
      if (nameController.text.isNotEmpty) {
        var resultFR = await Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => const TakePicture()),
        );
        if (resultFR != null) {
          cubit.saveImage(image: resultFR);
        }
      } else {
        showMessage("Pastikan tidak ada yang kosong !",
            "Pilih Nama terlebih dahulu", true, true);
      }
    } else {
      onPressedCamera(cubit);
    }
  }

  Widget header(HomeSpgCubit cubit) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: 230,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "Kunjungan",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: AppColors.redText,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  GeneralHelper().convertDateToString(
                      dateTime: DateTime.now(),
                      dateFormat: "EEEE, dd MMMM yyyy")!,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey40,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            spaceHeight(height: 20),
            StreamBuilder<DateTime>(
                stream: _dateTimeStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Format waktu menggunakan intl
                    String formattedTime =
                        DateFormat('HH:mm:ss', 'id_ID').format(snapshot.data!);
                    return Expanded(
                      flex: 2,
                      child: Text(
                        formattedTime,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          color: AppColors.black60,
                          fontSize: 30,
                        ),
                      ),
                    );
                  } else {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: const CustomLoading.defaultShape(
                          heightLoading: 15,
                        ),
                      ),
                    );
                  }
                }),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    buttonWidth: (MediaQuery.of(context).size.width / 3).w,
                    borderColor: AppColors.purple,
                    backgroundColor: MaterialStateProperty.all(
                      AppColors.purple,
                    ),
                    title: "Masuk",
                    action: () async {
                      
                      cubit.checkRadiusStore();

                      await cubit.stream
                          .firstWhere((state) => state is HomeSpgLoaded);

                      double? radius = cubit.radiusUser;
                      double? radiusStore = double.parse(cubit.radiusStore!);

                      if (radius! < radiusStore) {
                        if (await Permission
                            .locationWhenInUse.serviceStatus.isDisabled) {
                          showLocationMessage(
                              message:
                                  "Tolong aktifkan lokasi terlebih dahulu !");
                        } else {
                          if (nameController.text.isNotEmpty) {
                            showMessage(
                                "Apakah anda yakin?",
                                "Absen masuk pada tanggal ${GeneralHelper().convertDateToString(dateTime: DateTime.now())}",
                                true,
                                false);
                          } else {
                            showMessage("Pastikan tidak ada yang kosong !",
                                "Pilih Nama terlebih dahulu", true, true);
                          }
                        }
                      } else {
                        showLocationMessage(
                            title: "Anda berada diluar Area",
                            message:
                                "Tidak boleh absen diluar area yang sidah ditentukan!");
                      }
                   
                    },
                    withIcon: false,
                    active: true,
                  ),
                  CustomButton(
                    buttonWidth: (MediaQuery.of(context).size.width / 3).w,
                    borderColor: AppColors.redButton,
                    backgroundColor: MaterialStateProperty.all(
                      AppColors.redButton,
                    ),
                    title: "Keluar",
                    action: () async {
                        
                      cubit.checkRadiusStore();

                      await cubit.stream
                          .firstWhere((state) => state is HomeSpgLoaded);

                      double? radius = cubit.radiusUser;
                      double? radiusStore = double.parse(cubit.radiusStore!);
                      log("Radius User : ${radius.toString()}");
                      log("Radius Store : ${radiusStore.toString()}");

                      if (radius! < radiusStore) {
                        if (await Permission
                            .locationWhenInUse.serviceStatus.isDisabled) {
                          showLocationMessage(
                              message:
                                  "Tolong aktifkan lokasi terlebih dahulu !");
                        } else {
                          if (nameController.text.isNotEmpty) {
                            showMessage(
                              "Apakah anda yakin?",
                              "Absen keluar pada tanggal ${GeneralHelper().convertDateToString(dateTime: DateTime.now())}",
                              false,
                              false,
                            );
                          } else {
                            showMessage("Pastikan tidak ada yang kosong !",
                                "Pilih Nama terlebih dahulu", true, true);
                          }
                        }
                      } else {
                        showLocationMessage(
                            title: "Anda berada diluar Area",
                            message:
                                "Tidak boleh absen diluar area yang sidah ditentukan!");
                      }
                    },
                    withIcon: false,
                    active: true,
                  ),
                ],
              ),
            ),
            spaceHeight(height: 5),
          ],
        ),
      ),
    );
  }

  showLocationMessage({
    String? message,
    String? title = "Terjadi Kesalahan",
  }) {
    return CustomBottomSheet().showCustomBottomSheet(
      context: context,
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

  showSubmitMessage(BuildContext context, String? title, String? message) {
    return CustomBottomSheet().showCustomBottomSheet(
        context: context,
        title: title!,
        titleIcon: "assets/icons/ic_caution_blue.svg",
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
            title: "OK",
            action: () => Navigator.pop(context),
            withIcon: false,
            active: true,
          ),
        ));
  }

  showMessage(
      String? title, String? message, bool? isMasuk, bool? isOneButton) {
    final cubit = context.read<HomeSpgCubit>();
    return CustomBottomSheet().showCustomBottomSheet(
      context: context,
      title: title!,
      titleIcon: isMasuk!
          ? "assets/icons/ic_caution_red.svg"
          : "assets/icons/ic_caution_blue.svg",
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
      bottomContent: isOneButton!
          ? Container(
              padding: const EdgeInsets.all(SizeUtils.basePaddingMargin16),
              child: CustomButton(
                title: "Coba Lagi",
                action: () => Navigator.pop(context),
                withIcon: false,
                active: true,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(SizeUtils.basePaddingMargin16),
                  child: CustomButton(
                    buttonWidth: MediaQuery.of(context).size.width / 3,
                    title: "Batalkan",
                    action: () => Navigator.pop(context),
                    withIcon: false,
                    active: true,
                    backgroundColor: MaterialStateProperty.all(
                      AppColors.white,
                    ),
                    borderColor: AppColors.primary,
                    textColor: AppColors.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(SizeUtils.basePaddingMargin16),
                  child: CustomButton(
                    buttonWidth: MediaQuery.of(context).size.width / 3,
                    title: "Ya, Lanjutkan",
                    action: () {
                      Navigator.pop(context);

                      cubit.postInCubit(
                        category: isMasuk ? "in" : "out",
                      );
                     
                    },
                    withIcon: false,
                    active: true,
                  ),
                )
              ],
            ),
    );
  }

  Future<dynamic> showStoreList(
    HomeSpgCubit cubit,
  ) {
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
        return BlocProvider<HomeSpgCubit>(
          create: (context) => HomeSpgCubit()..getListSPGName(),
          child: BlocBuilder<HomeSpgCubit, HomeSpgState>(
            builder: (context, state) {
              var cubitDropdown = context.read<HomeSpgCubit>();

              List<DataSpg> listSPG = [];

              listSPG.addAll(cubitDropdown.listSPG);

              return openDropdownMenuWithSearch(
                context: context,
                searchController: searchController,
                scrollController: scrollFilterController,
                searchHint: "Pilih Nama",
                emptyMessage: "Data kosong",
                bottomSheetTitle: "Pilih Nama",
                itemCount: (state is HomeSpgFilterLoading)
                    ? 5
                    : listSPG.isNotEmpty
                        ? (listSPG.length == 1)
                            ? 1
                            : listSPG.length
                        : 0,
                itemBuilder: (BuildContext context, int index) {
                  if (state is HomeSpgFilterLoading) {
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

                  var nama = listSPG[index];
                  var fontWeight = FontWeight.w400;
                  var color = AppColors.transparent;

                  if (nameController.text == nama.toString()) {
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
                            nama.userName,
                            style: GoogleFonts.nunito(
                              fontWeight: fontWeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      nameController.text = nama.userName;
                      
                      cubit.dataSPG = nama;

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
