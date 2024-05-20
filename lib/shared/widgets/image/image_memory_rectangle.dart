library custom_image;

import 'dart:convert';

import 'package:flutter/material.dart';

class ImageMemoryRectangle extends StatefulWidget {
  final double? width, height;
  final String? imageUrl;
  final AlignmentGeometry? alignment;
  final BoxFit? boxFit;

  const ImageMemoryRectangle({
    super.key,
    this.width,
    this.height,
    this.imageUrl,
    this.alignment,
    this.boxFit,
  });

  @override
  State<ImageMemoryRectangle> createState() => ImageMemoryRectangleState();
}

class ImageMemoryRectangleState extends State<ImageMemoryRectangle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: widget.alignment,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: Image.memory(
        base64Decode(widget.imageUrl!),
        fit: widget.boxFit,
      ),
    );
  }
}
