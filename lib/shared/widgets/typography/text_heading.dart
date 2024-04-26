library typography;

import 'package:flutter/material.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';

class TextHeading extends StatelessWidget {
  final Color? color;
  final int? maxLines;
  final double? fontSize;
  final String? longText;
  final TextAlign? align;
  final FontWeight? weight;
  final TextOverflow? overflow;
  final double? height;

  const TextHeading({
    Key? key,
    required this.longText,
    this.color,
    this.align,
    this.weight,
    this.fontSize,
    this.maxLines,
    this.overflow,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      longText!.trim(),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: align ?? TextAlign.start,
      style: TextStyle(
        color: color,
        fontFamily: "Roboto",
        fontSize: fontSize ?? SizeUtils.baseTextSize14,
        fontWeight: weight ?? FontWeight.normal,
        decoration: TextDecoration.none,
        height: height ?? 1.15,
      ),
    );
  }
}
