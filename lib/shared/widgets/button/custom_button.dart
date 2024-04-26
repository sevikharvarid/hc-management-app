import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final VoidCallback? action;
  final bool? active, withIcon;
  final IconData? icon;
  final double? margin;
  final double? buttonWidth;
  final double? buttonHeight;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? borderColor;
  final bool? isTransformIcon;
  final MaterialStateProperty<Color?>? backgroundColor;

  const CustomButton(
      {Key? key,
      required this.title,
      required this.action,
      required this.withIcon,
      required this.active,
      this.icon,
      this.margin = 4,
      this.fontWeight,
      this.buttonWidth,
      this.buttonHeight,
      this.backgroundColor,
      this.textColor,
      this.borderColor,
      this.isTransformIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth ?? MediaQuery.of(context).size.width,
      height: buttonHeight ?? SizeUtils.baseWidthHeight40,
      margin: EdgeInsets.all(margin!),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: backgroundColor ??
              MaterialStateProperty.all(
                active! ? AppColors.primary : AppColors.grey30,
              ),
          splashFactory:
              active! ? InkSplash.splashFactory : NoSplash.splashFactory,
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(SizeUtils.basePaddingMargin8 * 5),
              side: BorderSide(
                width: 1,
                color: borderColor ??
                    (active! ? AppColors.primary : AppColors.white),
              ),
            ),
          ),
        ),
        onPressed: active! ? action : () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$title",
              style: TextStyle(
                fontSize: 16,
                fontWeight: fontWeight ?? FontWeight.normal,
                color:
                    textColor ?? (active! ? AppColors.white : AppColors.white),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            withIcon!
                ? Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: isTransformIcon!
                          ? Matrix4.rotationY(math.pi)
                          : Matrix4.rotationY(0),
                      child: Icon(
                        icon,
                        color: active! ? AppColors.white : AppColors.white,
                        size: 16,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
