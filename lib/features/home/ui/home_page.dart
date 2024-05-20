import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/config/routes.dart';
import 'package:hc_management_app/features/check_in/ui/check_in_page.dart';
import 'package:hc_management_app/features/home/cubit/home_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';
import 'package:hc_management_app/shared/widgets/card/visit_cart_item.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_loading.dart';
import 'package:hc_management_app/shared/widgets/image/image_network_rectangle.dart';
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
      listener: (context, state) {},
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
                        buildMenu(
                        ),
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
                        ListView.separated(
                          padding: const EdgeInsets.only(top: 4, bottom: 20),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                          separatorBuilder: (context, index) => const SizedBox(
                              height: SizeUtils.basePaddingMargin2),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.checkoutSales);
                              },
                              child: const VisitCardItem(
                                attendanceDate: "Wed, 17 Jan 2024",
                                startDateTime: "08:59",
                                endDateTime: "10:20",
                                typeAbsence: "in",
                                spgName: "Wahyu",
                                storeName: "Toko sejahtera Abadi",
                                storeCode: "KD01",
                                soNumber: "S0XXXXX9",
                                // endDayTime: "18:00",
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

  Widget buildMenu() {
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
                action: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => const CheckInPage(),
                    ),
                  );
                },
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
                action: () {},
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
}
