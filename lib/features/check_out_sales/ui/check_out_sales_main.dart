import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hc_management_app/features/check_out_sales/cubit/check_out_sales_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_widget.dart';

class CheckoutSalesMainPage extends StatefulWidget {
  const CheckoutSalesMainPage({Key? key}) : super(key: key);

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

    return BlocConsumer<CheckOutSalesCubit, CheckOutSalesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: customAppBar(
            items: labelMenu.length,
            systemUiOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.transparent,
            ),
            controller: controller,
            title: "Toko : ",
            subTitle: "Kode :",
            indexTabController: cubit.currentIndex!,
            labelTab: labelMenu,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
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
