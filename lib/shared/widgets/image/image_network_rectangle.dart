library custom_image;

import 'package:flutter/material.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/widgets/dropdown/dropdown_with_search.dart';

class ImageNetworkRectangle extends StatefulWidget {
  final double? width, height;
  final String? imageUrl;
  final AlignmentGeometry? alignment;
  final BoxFit? boxFit;

  const ImageNetworkRectangle({
    super.key,
    this.width,
    this.height,
    this.imageUrl,
    this.alignment,
    this.boxFit,
  });

  @override
  State<ImageNetworkRectangle> createState() => ImageNetworkRectangleState();
}

class ImageNetworkRectangleState extends State<ImageNetworkRectangle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: widget.alignment,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: Image.network(
        widget.imageUrl!,
        fit: widget.boxFit,
        loadingBuilder:
            (BuildContext context, Widget child, ImageChunkEvent? loading) {
          if (loading == null) return child;
          return loadingProgress();
        },
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.person,
            color: AppColors.black,
          );
        },
      ),
    );
  }
}
