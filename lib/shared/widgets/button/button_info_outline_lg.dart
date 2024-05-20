library button;

import 'package:flutter/material.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';

class ButtonInfoOutlineLg extends StatelessWidget {
  final String? title;
  final VoidCallback? action;
  final bool? active, withIcon;
  final Widget? icon;
  final Color? outlineColor;
  final Color? iconColor;
  final Color? textColor;
  final double? fontSize;
  final double? borderWidth;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? margin;

  const ButtonInfoOutlineLg(
      {super.key,
      required this.title,
      required this.action,
      required this.withIcon,
      required this.active,
      this.icon,
      this.outlineColor,
      this.iconColor,
      this.borderWidth,
      this.textColor,
      this.fontSize,
      this.buttonWidth,
      this.buttonHeight,
      this.margin = SizeUtils.basePadding});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: title,
      child: Container(
        width: buttonWidth ?? MediaQuery.of(context).size.width,
        height: buttonHeight ?? SizeUtils.baseWidthHeight48,
        margin: EdgeInsets.all(margin!),
        child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              active! ? AppColors.white : AppColors.grey,
            ),
            foregroundColor: MaterialStateProperty.all(
              active! ? AppColors.primary : AppColors.grey,
            ),
            splashFactory:
                active! ? InkSplash.splashFactory : NoSplash.splashFactory,
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeUtils.baseRoundedCorner * 5),
              ),
            ),
            side: MaterialStateProperty.all(
              BorderSide(
                color: outlineColor ?? AppColors.redButton,
                width: borderWidth ?? 2,
              ),
            ),
          ),
          onPressed: action,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                withIcon! ? icon! : const SizedBox(),
                Text(
                  "$title",
                  style: TextStyle(
                    fontSize: fontSize ?? SizeUtils.baseTextSize16,
                    fontWeight: FontWeight.normal,
                    color: textColor ??
                        (active! ? AppColors.redButton : AppColors.grey400),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
