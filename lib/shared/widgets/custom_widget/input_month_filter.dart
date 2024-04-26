library form;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/utils/helpers/month_pickers.dart';

class InputMonthField extends StatelessWidget {
  final TextEditingController? controller;
  final String? bottomSheetLabel;
  final double? width;
  final double? height;
  final FutureOr<dynamic> Function(void)? onSelected;

  const InputMonthField({
    Key? key,
    this.controller,
    this.bottomSheetLabel,
    this.width,
    this.height,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? SizeUtils.baseWidthHeight28,
      width: width ?? MediaQuery.of(context).size.width * 0.43,
      child: TextFormField(
        controller: controller!,
        readOnly: true,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: SizeUtils.baseTextSize14,
        ),
        decoration: InputDecoration(
          hintText: "Filter Tanggal",
          contentPadding:
              const EdgeInsets.only(left: SizeUtils.basePaddingMargin12),
          suffixIcon: Container(
            margin: const EdgeInsets.only(right: SizeUtils.basePaddingMargin12),
            child: const Icon(
              Icons.arrow_drop_down,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.neutral7, width: 1),
            borderRadius: BorderRadius.circular(
              8,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.neutral7, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onTap: () {
          openCustomMonthPicker(
            context: context,
            bottomSheetLabel: bottomSheetLabel,
            controller: controller,
          ).then(onSelected!);
        },
      ),
    );
  }
}
