import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:fluttericon/entypo_icons.dart';
class AppBarText extends StatelessWidget{
  final bool isDark;
  final String label;
  final VoidCallback onPressed;
  final keyAppBar;


  const AppBarText({
    required this.keyAppBar,
    required this.onPressed,
    required this.isDark,
    required this.label,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var fontColor = isDark ? white :  black;
    var backgroundColor = isDark ? black2 : white;
    return Container(
      key: keyAppBar,
      width: screenWidth,
      alignment: Alignment.centerLeft,
      height: screenWidth * 0.15,
      decoration: BoxDecoration(
        color:backgroundColor,
        boxShadow: [
          BoxShadow(
            color: isDark ? white.withOpacity(0.3) : black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: defaultPadding,
          ),
          ButtonPinch(
            onPressed:onPressed,
            scale: 0.95,
            boxColor: transparent,
            isShadow: false,
            isBorder: false,
            enable: true,
            radius: 0,
            paddingChild: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: (screenWidth * 0.15)/2,
              color: fontColor,
            ),
          ),
          const SizedBox(
            width: defaultPadding/2,
          ),
          Text(
           label,
            style: Helpers.font1(15.0, fontColor, FontWeight.w600),
            maxLines: 4,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
class AppBarLogo extends StatelessWidget{
  final bool isDark;
  final keyAppBar;

  const AppBarLogo({
    required this.keyAppBar,
    required this.isDark,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      key: keyAppBar,
      width: screenWidth,
      alignment: Alignment.centerLeft,
      height: screenWidth * 0.15,
      padding: const EdgeInsets.only(left: defaultPadding,right: defaultPadding),
      decoration: BoxDecoration(
        color:basic,
        boxShadow: [
          BoxShadow(
            color: isDark ? white.withOpacity(0.3) : black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageLogo(
            width:(screenWidth * 0.15) / 2,
            isDark: true,
          ),
          ButtonPinch(
            onPressed:(){
              Helpers.showAlert(
                context,
                PopUpMenu(
                  isDark: isDark,
                  isBahasaIndo: true,
                  context: context,
                ),
              );
            },
            scale: 0.95,
            boxColor: transparent,
            isShadow: false,
            isBorder: false,
            enable: true,
            paddingChild: const EdgeInsets.all(0.0),
            child: Image.asset(
              "assets/img/menuHeader.png",
              width: (screenWidth * 0.15)/2.3,
              height: (screenWidth * 0.15)/2.3,
            ),
          )
        ],
      ),
    );
  }
}