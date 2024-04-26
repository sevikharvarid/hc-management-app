import 'package:flutter/material.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';

Widget customHorizontalDivider({
  double? height,
  Color? color,
  double? thickness,
}) {
  return Divider(
    height: height,
    color: color ?? AppColors.grey400,
    thickness: thickness,
  );
}
