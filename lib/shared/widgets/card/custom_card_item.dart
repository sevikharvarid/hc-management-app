import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';

class CustomCardItem extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  final Function()? onLongPress;
  final double? marginLeft;
  final bool? withIcon;
  final Widget? widgetIcon;

  const CustomCardItem(
      {super.key,
      this.title,
      this.onTap,
      this.onLongPress,
      this.marginLeft,
      this.widgetIcon,
      this.withIcon = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 8, top: 8, left: marginLeft ?? 0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8), // Radius sudut
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Warna bayangan
              spreadRadius: 4, // Jarak bayangan ke segala arah
              blurRadius: 3, // Intensitas kabur bayangan
              offset: const Offset(
                0,
                2,
              ), // Geser bayangan (horisontal, vertikal)
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widgetIcon!,
            spaceWidth(width: 12.w),
            Expanded(
              child: SizedBox(
                width: 250,
                child: Text(
                  title!,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: AppColors.black80,
                  ),
                ),
              ),
            ),
            if (withIcon!)
              Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(Icons.arrow_back_ios, color: AppColors.black))
          ],
        ),
      ),
    );
  }
}
