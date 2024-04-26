library custom_widget;

import 'package:flutter/material.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:shimmer/shimmer.dart';

class CustomLoading extends StatefulWidget {
  final double heightLoading;
  final double widthLoading;
  final ShapeBorder shapeStyle;

  const CustomLoading.defaultShape({
    super.key,
    required this.heightLoading,
    this.widthLoading = double.infinity,
    this.shapeStyle = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(
          SizeUtils.basePadding,
        ),
      ),
    ),
  });

  const CustomLoading.defaultShape24({
    super.key,
    required this.heightLoading,
    this.widthLoading = double.infinity,
    this.shapeStyle = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(
          SizeUtils.baseRoundedCorner24,
        ),
      ),
    ),
  });

  const CustomLoading.profileShape({
    super.key,
    required this.heightLoading,
    required this.widthLoading,
    this.shapeStyle = const CircleBorder(),
  });

  const CustomLoading.buttonShape({
    super.key,
    required this.heightLoading,
    required this.widthLoading,
    this.shapeStyle = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(
          SizeUtils.basePadding * 5,
        ),
      ),
    ),
  });

  @override
  State<StatefulWidget> createState() => CustomLoadingState();
}

class CustomLoadingState extends State<CustomLoading> {
  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: AppColors.grey300!,
        highlightColor: AppColors.grey100!,
        // period: Duration(seconds: 8),
        child: Container(
          width: widget.widthLoading,
          height: widget.heightLoading,
          padding: const EdgeInsets.all(
            SizeUtils.basePadding / 2,
          ),
          decoration: ShapeDecoration(
            color: AppColors.grey600,
            shape: widget.shapeStyle,
          ),
        ),
      );
}
