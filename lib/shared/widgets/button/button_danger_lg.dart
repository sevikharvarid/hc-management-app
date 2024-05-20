library button;

import 'package:flutter/material.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';

class ButtonDangerLg extends StatelessWidget {
  final String? title;
  final VoidCallback? action;
  final bool? active, withIcon;
  final IconData? icon;
  final double? buttonWidth;
  final double? margin;
  final Color? backgroundColor;

  const ButtonDangerLg({
    super.key,
    this.title,
    this.action,
    this.active,
    required this.withIcon,
    this.icon,
    this.buttonWidth,
    this.margin,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth ?? MediaQuery.of(context).size.width,
      height: 48,
      margin: EdgeInsets.all(margin ?? SizeUtils.basePadding),
      child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              backgroundColor ?? AppColors.red60,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeUtils.baseRoundedCorner50),
              ),
            ),
          ),
          onPressed: action,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                withIcon!
                    ? Container(
                        margin:
                            const EdgeInsets.only(right: SizeUtils.basePadding),
                        child: Icon(
                          icon,
                          size: 20,
                          color: active! ? AppColors.white : AppColors.grey400,
                        ),
                      )
                    : const SizedBox(),
                Text(
                  "$title",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: SizeUtils.baseTextSize16,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ])),
    );
  }
}
