library custom_widget;

import 'package:flutter/material.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/widgets/image/image_svg_asset_rectangle.dart';

class CustomContainerWidget extends StatelessWidget {
  final Widget child;
  final String? imageUrl;
  final BoxFit? boxFit;
  final double? width, height;
  final Alignment? alignment;
  final Color? backgroundColor;

  const CustomContainerWidget({
    Key? key,
    required this.child,
    this.imageUrl,
    this.boxFit,
    this.height,
    this.width,
    this.alignment,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppColors.white,
      child: Stack(
        children: [
          imageUrl!.isNotEmpty
              ? ImageSvgAssetRectangle(
                  width: MediaQuery.of(context).size.width,
                  height: height,
                  imageUrl: imageUrl,
                  boxFit: boxFit ?? BoxFit.fitWidth,
                  alignment: alignment ?? Alignment.center,
                )
              : Container(),
          child,
        ],
      ),
    );
  }
}
