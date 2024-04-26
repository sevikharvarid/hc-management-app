import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/domain/model/menus.dart';
import 'package:hc_management_app/features/check_in/ui/check_in_page.dart';
import 'package:hc_management_app/features/home/cubit/home_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';
import 'package:hc_management_app/shared/widgets/card/attendance_card_item.dart';
import 'package:hc_management_app/shared/widgets/card/custom_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _changeColor = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
                          "Morning,",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "Vera Angelina",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
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
                                  .grey, // Ganti dengan warna yang diinginkan
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
                        const CustomCard(),
                        spaceHeight(height: 20),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: 4, horizontal: 16),
                        //   child: Text(
                        //     "Toko Sejahtera Abadi",
                        //     style: GoogleFonts.nunito(
                        //       fontWeight: FontWeight.bold,
                        //       color: AppColors.white,
                        //       fontSize: 14,
                        //     ),
                        //   ),
                        // ),
                        buildMenu(
                          menus: cubit.menus,
                        ),
                        spaceHeight(height: SizeUtils.basePaddingMargin8),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Attendance",
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
                                // onTap: () => BlocProvider<RequestSalesCubit>(
                                //   create: (context) =>
                                //       RequestSalesCubit()..initCubit(),
                                //   child: const RequestSalesPage(),
                                // ),
                                onTap: () {},
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
                                onTap: () {},
                                child: const AttendanceCardItem(
                                  attendanceDate: "Wed, 17 Jan 2024",
                                  startDayTime: "08:59",
                                  endDayTime: "18:00",
                                ));
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

  Widget buildMenu({
    List<Menus>? menus,
  }) {
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
