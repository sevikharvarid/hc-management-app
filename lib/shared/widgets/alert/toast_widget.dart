library alert;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/image/image_svg_asset_rectangle.dart';

void showToast({required BuildContext context, required Widget child}) {
  return FToast().init(context).showToast(
        toastDuration: const Duration(seconds: 5),
        gravity: ToastGravity.TOP,
        child: child,
      );
}

class ToastWidget extends StatelessWidget {
  final Color? backgroundColor, borderColor;
  final String? message;
  final String? icon, accessibilityId;
  final EdgeInsetsGeometry? margin;
  final FontWeight? fontWeight;
  final double? lineHeight;
  final double? fontSize;
  final double? marginTop;
  final bool? isCenter;

  const ToastWidget({
    Key? key,
    required this.backgroundColor,
    required this.borderColor,
    required this.message,
    this.icon,
    this.accessibilityId,
    this.margin,
    this.fontWeight,
    this.lineHeight,
    this.fontSize = SizeUtils.baseTextSize16,
    this.marginTop,
    this.isCenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      excludeSemantics: true,
      label: accessibilityId,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(SizeUtils.baseRoundedCorner4),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SizeUtils.basePaddingMargin16,
            vertical: SizeUtils.basePaddingMargin10,
          ),
          decoration: BoxDecoration(
            color: backgroundColor!,
            border: Border.all(color: borderColor!, width: 1),
            borderRadius: BorderRadius.circular(SizeUtils.baseRoundedCorner4),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: (isCenter == true)
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              ImageSvgAssetRectangle(
                width: SizeUtils.baseWidthHeight14,
                height: SizeUtils.baseWidthHeight14,
                imageUrl: "$icon",
              ),
              const SizedBox(width: SizeUtils.basePadding),
              Expanded(
                flex: 1,
                child: Text(
                  message!,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.nunito(
                    fontWeight: fontWeight,
                    fontSize: fontSize,
                    height: lineHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
