library alert;

import 'package:flutter/material.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';

SnackBar snackBarWidget({
  required BuildContext context,
  required String? message,
  required VoidCallback callback,
  required bool? isAvailable,
}) {
  return SnackBar(
    content: isAvailable!
        ? Text(message!)
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Terjadi kesalahan",
              ),
              spaceHeight(height: 50),
              Text(
                message!,
              )
            ],
          ),
    action: SnackBarAction(
      label: "Close",
      textColor: AppColors.lightRed,
      onPressed: callback,
    ),
    margin: const EdgeInsets.all(SizeUtils.basePadding * 2),
    behavior: SnackBarBehavior.floating,
  );
}
