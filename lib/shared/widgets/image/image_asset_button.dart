library custom_image;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageAssetButton extends StatelessWidget {
  final double? width, height;
  final String? imageUrl;
  final VoidCallback? action;

  const ImageAssetButton({
    super.key,
    this.width,
    this.height,
    this.imageUrl,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: IconButton(
        icon: SvgPicture.asset(
          imageUrl!,
          width: width,
          height: height,
          fit: BoxFit.fill,
          cacheColorFilter: false,
        ),
        onPressed: action,
      ),
    );
  }
}
