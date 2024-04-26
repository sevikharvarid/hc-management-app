import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/alert/custom_bottom_sheet.dart';
import 'package:hc_management_app/shared/widgets/alert/snack_bar_widget.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';
import 'package:hc_management_app/shared/widgets/location_service/bloc/location_service_bloc.dart';
import 'package:hc_management_app/shared/widgets/location_service/bloc/location_service_state.dart';

class LocationServiceWidget extends StatefulWidget {
  final Widget child;

  const LocationServiceWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LocationServiceWidgetState();
}

class LocationServiceWidgetState extends State<LocationServiceWidget> {
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    return BlocConsumer<LocationServiceBloc, LocationServiceState>(
      listener: (context, state) {
        log("state is : $state");
        if (state is LocationServiceAvailable) {
          scaffold.showSnackBar(
            snackBarWidget(
              context: context,
              message: "Lokasi Aktif",
              callback: scaffold.hideCurrentSnackBar,
              isAvailable: true,
            ),
          );
        }

        if (state is LocationServiceUnavailable) {
          scaffold.showSnackBar(
            snackBarWidget(
              context: context,
              message: "Silahkan Aktifkan lokasi terlebih dahulu",
              callback: scaffold.hideCurrentSnackBar,
              isAvailable: false,
            ),
          );
        }
      },
      builder: (context, state) {
        return Container(
          child: widget.child,
        );
      },
    );
  }

  showLocationMessage(BuildContext context, String? title, String? message) {
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
            action: () {
              // if(){

              // }
              Navigator.pop(context);
              // openAppSettings();
            },
            withIcon: false,
            active: true,
          ),
        ));
  }
}
