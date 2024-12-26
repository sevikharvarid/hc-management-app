import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/config/routes.dart';
import 'package:hc_management_app/domain/model/stores.dart';
import 'package:hc_management_app/domain/model/visits.dart';
import 'package:hc_management_app/features/check_in/ui/check_in_page.dart';
import 'package:hc_management_app/features/home/cubit/home_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/widgets/alert/progress_dialog.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';
import 'package:hc_management_app/shared/widgets/card/visit_cart_item.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_loading.dart';
import 'package:hc_management_app/shared/widgets/dropdown/dropdown_with_search.dart';
import 'package:hc_management_app/shared/widgets/image/image_lottie.dart';
import 'package:hc_management_app/shared/widgets/image/image_network_rectangle.dart';
import 'package:hc_management_app/shared/widgets/text_field/custom_text_field.dart';
import 'package:hc_management_app/shared/widgets/text_field/input_text_field_default.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onClickViewAll;

  const HomePage({
    super.key,
    this.onClickViewAll,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Field Pop up toko
  TextEditingController namaToko = TextEditingController();
  TextEditingController storeController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  ScrollController scrollFilterController = ScrollController();


  final ScrollController _scrollController = ScrollController();
  bool _changeColor = false;

  late StreamController<DateTime> _dateTimeController;
  late Stream<DateTime> _dateTimeStream;
  late Timer _timeUpdater;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 203) {
      setState(() {
        _changeColor = true;
      });
    } else {
      setState(() {
        _changeColor = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeLoading) {
          showProgressDialog(context: context);
        }

        if (state is HomeLoaded) {
          Navigator.pop(context);
          cubit.checkGPS();
        }

        if (state is HomeSuccessGet) {}
      },
      builder: (context, state) {
        return Scaffold(
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
                controller: _scrollController,
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
                            fontSize: 20,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          cubit.name ?? "No Name",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppColors.white,
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
                            child: (cubit.photoProfile != null &&
                                    cubit.photoProfile != '')
                                ? ClipOval(
                                    child: ImageNetworkRectangle(
                                      width: SizeUtils.baseWidthHeight110,
                                      height: SizeUtils.baseWidthHeight110,
                                      imageUrl:
                                          "https://visit.sanwin.my.id/storage/storage/${cubit.photoProfile}",
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
                        buildMenu(),
                        spaceHeight(height: SizeUtils.basePaddingMargin8),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Visits",
                                style: GoogleFonts.nunito(
                                  color: _changeColor
                                      ? AppColors.white
                                      : AppColors
                                          .black, // Change color conditionally
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.onClickViewAll!.call();
                                },
                                child: Text(
                                  "View All",
                                  style: GoogleFonts.roboto(
                                    color: _changeColor
                                        ? AppColors.white
                                        : AppColors.blue70,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 20),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: cubit.visits.isEmpty
                                    ? 0
                                    : (cubit.visits.length > 3)
                                        ? 3
                                        : cubit.visits.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                        height: SizeUtils.basePaddingMargin2),
                                itemBuilder: (context, index) {
                                  var data = cubit.visits[index];

                                  // log("totalQ")

                                  return GestureDetector(
                                    onTap: () => onPressedCardList(cubit, data),
                                    child: VisitCardItem(
                                      attendanceDateIn: data.inDate != null
                                          ? cubit.generalHelper
                                              .convertDateToString(
                                              dateFormat: "EEEE, dd MMMM yyyy",
                                              dateTime:
                                                  DateTime.parse(data.inDate!),
                                            )
                                          : '-',
                                      attendanceDateOut: data.outDate != null
                                          ? cubit.generalHelper
                                              .convertDateToString(
                                              dateFormat: "EEEE, dd MMMM yyyy",
                                              dateTime:
                                                  DateTime.parse(data.outDate!),
                                            )
                                          : '-',
                                      startDateTime: data.inTime,
                                      endDateTime: data.outTime ?? '-',
                                      storeName: data.storeName ?? '-',
                                      storeCode: data.storeCode ?? '-',
                                      soNumber: data.soCode ?? '-',
                                    ),
                                  );
                                },
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

  Widget header(HomeCubit cubit) {
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
          ],
        ),
      ),
    );
  }

  void onPressedCheckIn(HomeCubit cubit) async {
    bool gpsStatus = await cubit.checkAndTurnOnGPS();

    if (gpsStatus) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => const CheckInPage(),
        ),
      );
    } else {
      onPressedCheckIn(cubit);
    }
  }

  void onPressedOrderOnly(HomeCubit cubit) async {
    bool gpsStatus = await cubit.checkAndTurnOnGPS();

    if (gpsStatus) {
      Navigator.pushNamed(
        context,
        Routes.orderOnly,
        arguments: {
          'data': null,
        },
      );
    } else {
      onPressedOrderOnly(
        cubit,
      );
    }
  }

  void onPressedCardList(HomeCubit cubit, VisitData? data) async {
    bool gpsStatus = await cubit.checkAndTurnOnGPS();

    log("DATA GEDE BANGET :${const JsonEncoder.withIndent(' ').convert(data)}");

    if (gpsStatus) {
      Navigator.pushNamed(
        context,
        Routes.checkoutSales,
        arguments: {
          'data': data,
          'isFromHome': false,
        },
      );
    } else {
      onPressedCardList(cubit, data);
    }
  }

  Widget buildMenu() {
    var cubit = context.read<HomeCubit>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      height: 130,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color:
                Colors.grey.withOpacity(0.4), // Warna bayangan (shadow color)
            spreadRadius: 3, // Jarak penyebaran bayangan
            blurRadius: 4, // Jarak blur bayangan
            offset: const Offset(0, 3), // Perpindahan bayangan dari kontainer
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Icon(
                Icons.person_add_alt_1,
                color: AppColors.orange,
                size: 40,
              ),
              CustomButton(
                buttonWidth: MediaQuery.of(context).size.width / 2.5,
                borderColor: AppColors.purple,
                backgroundColor: MaterialStateProperty.all(
                  AppColors.purple,
                ),
                title: "Check In",
                action: () => onPressedCheckIn(cubit),
                withIcon: false,
                active: true,
              ),
            ],
          ),
          Column(
            children: [
              Icon(
                Icons.edit_calendar_sharp,
                color: AppColors.green,
                size: 40,
              ),
              CustomButton(
                buttonWidth: MediaQuery.of(context).size.width / 2.5,
                borderColor: Colors.green[700],
                backgroundColor: MaterialStateProperty.all(
                  AppColors.green,
                ),
                title: "Order Only",
                // action: () => onPressedOrderOnly(cubit),
                action: () => showPopup(context, cubit),
                withIcon: false,
                active: true,
              ),
            ],
          )
        ],
      ),
      // child: ListView.separated(
      //   physics: const NeverScrollableScrollPhysics(),
      //   scrollDirection: Axis.horizontal,
      //   itemCount: menus!.length,
      //   itemBuilder: (context, index) {
      //     return Column(
      //       children: [
      //         Icon(
      //           menus[index].iconData,
      //           color: menus[index].iconColor,
      //           size: 40,
      //         ),
      //         spaceHeight(height: 5),
      //         Text(
      //           menus[index].menuTitle!,
      //           style: GoogleFonts.nunito(
      //             color: AppColors.black,
      //             fontSize: 14,
      //           ),
      //         ),
      //       ],
      //     );
      //   },
      //   separatorBuilder: (context, index) => const SizedBox(
      //     width: SizeUtils.basePaddingMargin30,
      //   ),
      // ),
    );
  }

  void showPopup(BuildContext context, HomeCubit cubit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Toko'),
          // content: const Text('This is the content of the pop-up!'),
          content: Column(
            children: [
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
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: buildTextField(
                  isReadOnly: !cubit.isReadOnlyStore,
                  controller: namaToko,
                  hintText: "Masukkan Nama Toko",
                  label: "Nama Toko",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showStoreList(
    BuildContext context,
    HomeCubit cubit,
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
        return BlocProvider<HomeCubit>(
          create: (context) => HomeCubit()..getStoreData(),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              var cubitDropdown = context.read<HomeCubit>();

              List<DataStoreSales> listToko = [];

              listToko.addAll(cubitDropdown.listToko);

              return openDropdownMenuWithSearch(
                context: context,
                searchController: searchController,
                scrollController: scrollFilterController,
                searchHint: "Pilih Toko",
                emptyMessage: "Data kosong",
                bottomSheetTitle: "Pilih Toko",
                itemCount: (state is HomeStoreFilterLoading)
                    ? 5
                    : listToko.isNotEmpty
                        ? (listToko.length == 1)
                            ? 1
                            : listToko.length
                        : 0,
                itemBuilder: (BuildContext context, int index) {
                  if (state is HomeStoreFilterLoading) {
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
