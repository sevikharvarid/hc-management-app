library alert;

import 'package:flutter/material.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/typography/text_heading.dart';

Future showProgressDialog({
  required BuildContext context,
  bool isDismissible = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: isDismissible,
    barrierColor: AppColors.black.withOpacity(0.45),
    builder: (context) => WillPopScope(
      onWillPop: () async => isDismissible,
      child: Dialog(
        elevation: 0,
        insetPadding: const EdgeInsets.all(SizeUtils.basePaddingMargin64),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeUtils.basePaddingMargin10),
        ),
        child: Builder(
          builder: (context) => Container(
            width: SizeUtils.baseWidthHeight100,
            height: SizeUtils.baseWidthHeight110,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const TextHeading(
                  longText: "Loading..",
                  weight: FontWeight.w500,
                  align: TextAlign.center,
                ),
                const SizedBox(height: SizeUtils.baseWidthHeight16),
                SizedBox(
                  width: SizeUtils.baseWidthHeight38,
                  height: SizeUtils.baseWidthHeight38,
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget circularProgress(BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.white,
        )
      ],
    ),
  );
}
