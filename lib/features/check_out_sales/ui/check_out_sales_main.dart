import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hc_management_app/features/check_out_sales/cubit/check_out_sales_cubit.dart';
import 'package:hc_management_app/features/check_out_sales/ui/check_out_sales_page.dart';
import 'package:hc_management_app/features/check_out_sales/ui/input_so_sales_page.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_widget.dart';

class CheckoutSalesMainPage extends StatefulWidget {
  const CheckoutSalesMainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutSalesMainPage> createState() => CheckoutSalesMainPageState();
}

class CheckoutSalesMainPageState extends State<CheckoutSalesMainPage>
    with SingleTickerProviderStateMixin {
  late TabController controller = TabController(vsync: this, length: 2);

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<CheckOutSalesCubit>();
    List<String> labelMenu = ["Checkout", "Input SO"];
    if (cubit.isFromHome == true) {
      controller.animateTo(1);
    } 


    return BlocConsumer<CheckOutSalesCubit, CheckOutSalesState>(
      listener: (context, state) {
        if (state is CheckOutSalesLoading) {
          // showProgressDialog(context: context);
        }

        if (state is CheckOutSalesCheckout) {
          // Navigator.pop(context);
        }
      },
      builder: (context, state) {
        log("state : $state");
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: customAppBar(
            items: labelMenu.length,
            systemUiOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.primary,
            ),
            controller: controller,
            title: cubit.storeName ?? '',
            subTitle: "Kode : ${cubit.storeCode ?? ''}",
            indexTabController: cubit.currentIndex!,
            labelTab: labelMenu,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            onTap: (index) {
              controller.animateTo(index);
              cubit.changePage(index: index);
            },
          ),
          body: BlocBuilder<CheckOutSalesCubit, CheckOutSalesState>(
            builder: (context, state) {
              if (state is CheckOutSalesCheckout) {
                return BlocProvider<CheckOutSalesCubit>(
                  create: (context) => CheckOutSalesCubit({
                    'data': cubit.visitData,
                  })
                    ..initCheckoutSalesCubit(),
                  child: const CheckOutSalesPage(),
                );
              }

              if (state is CheckOutSalesInputSO) {
                log("Ssssfafag");
                return BlocProvider<CheckOutSalesCubit>(
                  create: (context) => CheckOutSalesCubit({
                    'data': cubit.visitData,
                  })
                    ..initInputSOPage(),
                  child: const InputSOSalesPage(),
                );
              }
              // if (state is SubmissionClockForm) {
              //   // Submission form
              //   return BlocProvider(
              //     create: (context) => SubmissionClockFormCubit()..initCubit(),
              //     child: SubmissionClockFormPage(),
              //   );
              // }

              // if (state is SubmissionClockHistory) {
              //   // Submission history
              //   return BlocProvider(
              //     create: (context) => SubmissionClockHistoryBloc()
              //       ..add(SubmissionHistoryStarted(context: context)),
              //     child: SubmissionClockHistoryPage(),
              //   );
              // }

              return Container();
            },
          ),
        );
      },
    );
  }
}
