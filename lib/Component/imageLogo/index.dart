import 'package:flutter/material.dart';

class ImageLogo extends StatelessWidget {
  final width;
  final height;
  final bool isDark;

  const ImageLogo({
    this.width,
    this.height,
    this.isDark = false,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var logoImage =
        isDark ? "assets/logo/LogoFR.png" : "assets/logo/LogoFR.png";
    return Image.asset(
      logoImage,
      width: width,
      height: height,
    );
  }
}
