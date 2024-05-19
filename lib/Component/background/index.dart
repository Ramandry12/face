import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:shimmer/shimmer.dart';

class Background extends StatelessWidget {
  final Widget child;
  final Alignment alignment;
  final bool isDarkTheme;
  final bool isBahasaIndo;
  final bool isShowSpinner;

  const Background({
    Key? key,
    required this.child,
    this.isDarkTheme = false,
    this.isShowSpinner = false,
    this.isBahasaIndo = true,
    this.alignment = Alignment.topLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        primary: false,
        toolbarHeight: 0,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: isDarkTheme ? black2 : basic,
      ),
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: false,
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            alignment: alignment,
            color: isDarkTheme ? black : white,
            child: child,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: isShowSpinner
                ? AlertLoading(
                    isDark: isDarkTheme,
                    isBahasaIndo: isBahasaIndo,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class IndicatorModalChild extends StatelessWidget {
  final BorderRadius? borderRadius;
  final bool isDark;

  const IndicatorModalChild({
    Key? key,
    this.borderRadius,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var QW = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: transparent,
        borderRadius: borderRadius ?? Helpers.onRadius(3, defaultPadding),
      ),
      padding: defaultEdge,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: defaultHeightIndicator,
            width: QW * .2,
            decoration: BoxDecoration(
              color: isDark ? white : black,
              borderRadius: Helpers.onRadius(1, defaultHeightIndicator),
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final double? height;
  final double? width;
  final BorderRadiusGeometry borderRadius;

  const ShimmerCard({
    Key? key,
    this.height,
    this.width,
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Shimmer.fromColors(
        baseColor: gray,
        highlightColor: white,
        child: Container(
          height: height,
          width: width,
          color: blackMed,
        ),
      ),
    );
  }
}
