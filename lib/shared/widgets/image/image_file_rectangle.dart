library custom_image;

import 'dart:io';

import 'package:flutter/material.dart';

class ImageFileRectangle extends StatefulWidget {
  final double? width, height;
  final File? imageUrl;
  final AlignmentGeometry? alignment;
  final BoxFit? boxFit;

  const ImageFileRectangle({
    super.key,
    this.width,
    this.height,
    this.imageUrl,
    this.alignment,
    this.boxFit,
  });

  @override
  State<ImageFileRectangle> createState() => ImageFileRectangleState();
}

class ImageFileRectangleState extends State<ImageFileRectangle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: widget.alignment,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: Image.file(
        widget.imageUrl!,
        fit: widget.boxFit,
      ),
    );
  }
}
