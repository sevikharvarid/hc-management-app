library custom_image;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageSvgAssetRectangle extends StatelessWidget {
  final double? width, height;
  final String? imageUrl;
  final AlignmentGeometry? alignment;
  final BoxFit? boxFit;
  final Color? color;

  const ImageSvgAssetRectangle({
    Key? key,
    this.width,
    this.height,
    this.imageUrl,
    this.alignment,
    this.boxFit,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: alignment ?? Alignment.centerLeft,
      child: SvgPicture.asset(
        imageUrl!,
        width: width,
        height: height,
        cacheColorFilter: false,
        color: color,
        fit: boxFit ?? BoxFit.scaleDown,
      ),
    );
  }
}
