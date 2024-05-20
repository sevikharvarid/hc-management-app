library form;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_widget.dart';
import 'package:hc_management_app/shared/widgets/image/image_svg_asset_rectangle.dart';

class InputDateField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label, hint, bottomSheetLabel, accessibilityId;
  final bool? isDateRange, enableLastDate;
  final DateTime? firstDate, lastDate;
  final Function()? onTap;
  final EdgeInsetsGeometry? margin;
  final FutureOr<dynamic> Function(dynamic)? onSelected;
  final String? errorText;
  final FontWeight? labelWeight;
  final Function(String)? onChanged;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool isActive;
  final Widget? suffixIcon;

  const InputDateField({
    Key? key,
    this.controller,
    this.label,
    this.hint,
    this.bottomSheetLabel,
    this.accessibilityId,
    this.isDateRange,
    this.onSelected,
    this.firstDate,
    this.lastDate,
    this.enableLastDate,
    this.onTap,
    this.margin,
    this.errorText,
    this.onChanged,
    this.labelWeight,
    this.textAlign,
    this.textAlignVertical,
    this.isActive = true,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GeneralHelper generalHelper = GeneralHelper();
    return Container(
      width: MediaQuery.of(context).size.width / 2.3,
      margin: margin ?? const EdgeInsets.all(SizeUtils.basePadding),
      padding: const EdgeInsets.all(4),
      child: TextFormField(
        style: TextStyle(
          fontSize: 12,
          color: isActive ? AppColors.black : AppColors.black60,
        ),
        textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
        textAlign: textAlign ?? TextAlign.left,
        controller: controller,
        readOnly: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          enabled: isActive,
          filled: true,
          fillColor: isActive ? AppColors.white : AppColors.neutral5,
          contentPadding: const EdgeInsets.only(
            left: SizeUtils.basePaddingMargin16,
          ),
          isDense: true,
          hintText: "$hint",
          hintStyle: TextStyle(
            color: AppColors.grey400!,
            fontSize: SizeUtils.baseTextSize12,
            fontWeight: FontWeight.normal,
          ),
          suffixIcon: suffixIcon ??
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: SizeUtils.basePaddingMargin16),
                child: const ImageSvgAssetRectangle(
                  alignment: Alignment.center,
                  height: SizeUtils.baseWidthHeight14,
                  width: SizeUtils.baseWidthHeight14,
                  imageUrl: "assets/icons/ic_calendar.svg",
                ),
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.grey400!,
              width: SizeUtils.baseWidthHeight1,
            ),
            borderRadius: BorderRadius.circular(
              SizeUtils.baseRoundedCorner50,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.grey400!,
              width: SizeUtils.baseWidthHeight1,
            ),
            borderRadius: BorderRadius.circular(
              SizeUtils.baseRoundedCorner50,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.grey400!,
              width: SizeUtils.baseWidthHeight1,
            ),
            borderRadius: BorderRadius.circular(
              SizeUtils.baseRoundedCorner50,
            ),
          ),
          labelStyle: TextStyle(
            color: AppColors.grey400,
            fontWeight: FontWeight.normal,
            fontSize: SizeUtils.baseTextSize14,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.redText,
              width: SizeUtils.baseWidthHeight1,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(SizeUtils.baseRoundedCorner50),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.redText,
              width: SizeUtils.baseWidthHeight1,
            ),
            borderRadius: BorderRadius.circular(
              SizeUtils.baseRoundedCorner50,
            ),
          ),
          errorText: errorText,
          errorStyle: TextStyle(
            color: AppColors.redText,
            fontSize: SizeUtils.baseTextSize14,
            fontWeight: FontWeight.normal,
          ),
        ),
        onTap: onTap ??
            () {
              List<Month>? enableDays;
              bool isCloseDatePicker = false;
              openCustomDatePicker(
                context,
                bottomSheetLabel!,
                controller!,
                isDateRange: isDateRange!,
                firstDate: firstDate!,
                lastDate: lastDate,
                enableDays: enableDays,
                closeDatePicker: (value) {
                  isCloseDatePicker = value;
                },
              ).then((_) {
                final value = controller!.text;
                dynamic dates;
                if (isDateRange!) {
                  // List of datetime
                  dates = generalHelper.convertStringToMultipleDate(
                      stringDate: value);
                } else {
                  dates = generalHelper.convertStringToDate(stringDate: value)!;
                }

                if (isCloseDatePicker == false) {
                  onSelected!(dates);
                }
              });
            },
      ),
    );
  }
}
