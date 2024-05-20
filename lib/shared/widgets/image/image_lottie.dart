import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ImageLottie extends StatelessWidget {
  final String? lottiePath;
  final double? width;
  final double? height;

  const ImageLottie({
    Key? key,
    required this.lottiePath,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LottieBuilder.asset(
      lottiePath!,
      width: width,
      height: height,
      fit: BoxFit.cover,
      repeat: true,
    );
  }
}
