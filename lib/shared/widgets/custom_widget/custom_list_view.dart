library custom_widget;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_widget.dart';

class CustomListView extends StatelessWidget {
  final bool? shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final int itemCount;
  final Widget Function(BuildContext, int)? itemBuilder;
  final bool? withHorizontalDivider;
  final double? heightEmptyWidget;
  final String emptyMessage;

  const CustomListView({
    Key? key,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
    this.heightEmptyWidget,
    this.withHorizontalDivider = true,
    required this.itemCount,
    required this.itemBuilder,
    required this.emptyMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) {
      return emptyWidget(context: context);
    }

    if (withHorizontalDivider!) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customHorizontalDivider(
            color: AppColors.grey300!,
            thickness: 1,
            height: 1,
          ),
          ListView.builder(
            shrinkWrap: shrinkWrap!,
            physics: physics,
            padding: padding,
            itemCount: itemCount,
            itemBuilder: itemBuilder!,
          )
        ],
      );
    } else {
      return ListView.builder(
        physics: physics,
        padding: padding,
        itemCount: itemCount,
        shrinkWrap: shrinkWrap!,
        itemBuilder: itemBuilder!,
      );
    }
  }

  Widget emptyWidget({
    required BuildContext context,
  }) {
    return Container(
      height: heightEmptyWidget,
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeUtils.basePaddingMargin16,
        ),
        child: Text(
          emptyMessage,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
