import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';

class FilePickerProgress extends StatelessWidget {
  final double? width;
  final double? height;
  final double? progressHeight;
  final Color? progressValueColor;
  final Color? progressBackgroundColor;
  const FilePickerProgress({
    super.key,
    this.width,
    this.height,
    this.progressHeight,
    this.progressValueColor,
    this.progressBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: AppColors.neutral5,
      strokeWidth: 1,
      dashPattern: const [3, 3],
      borderType: BorderType.RRect,
      radius: const Radius.circular(5),
      child: Container(
        width: width ?? SizeUtils.baseWidthHeight105,
        height: height ?? SizeUtils.baseWidthHeight105,
        padding: const EdgeInsets.all(SizeUtils.basePaddingMargin8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                tween: Tween<double>(
                  begin: 0,
                  end: 0.95,
                ),
                builder: (_, value, __) => LinearProgressIndicator(
                  minHeight: progressHeight ?? SizeUtils.baseWidthHeight8,
                  value: value,
                  backgroundColor: progressBackgroundColor ?? AppColors.grey60,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressValueColor ?? AppColors.blue50,
                  ),
                ),
              ),
            ),
            const SizedBox(height: SizeUtils.baseWidthHeight18),
            Text(
              "Uploads",
              style: GoogleFonts.nunito(
                fontSize: SizeUtils.baseTextSize12,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
