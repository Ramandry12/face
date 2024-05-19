import 'package:flutter/material.dart';

const white = Color.fromRGBO(255, 255, 255, 1.0);
const black = Color.fromRGBO(17, 17, 17, 1);
const black2 = Color.fromRGBO(20, 23, 19, 1);
const textFieldDark = Color.fromRGBO(55, 57, 69, 1);
const blackMed = Color.fromRGBO(249, 250, 251, 1);
const blackLow = Color.fromRGBO(240, 240, 240, 1);
const gray = Color.fromRGBO(218, 218, 218, 1);
const grayCase = Color.fromRGBO(244, 244, 244, 1);
const transparent = Colors.transparent;

const basic = Color.fromRGBO(1, 56, 63, 1);
const basicA = Color.fromRGBO(255, 184, 0, .4);
const basicB = Color.fromRGBO(80, 160, 255, 1);
const basicC = Color.fromRGBO(0, 102, 255, 1);
const basicD = Color.fromRGBO(7, 149, 194, 1);
const basicE = Color.fromRGBO(3, 149, 96, 1);
const basicF = Color.fromRGBO(251, 214, 119, 1);

const Red = Color.fromRGBO(255, 26, 26, 1);
const Red_A = Color.fromRGBO(255, 102, 102, 1);
const Green = Color.fromRGBO(3, 89, 0, 1);
const Green_A = Color.fromRGBO(87, 144, 85, 1);

const int defaultQuantity = 1000000;
const int defaultCacheSize = 200;
const int defaultDuration = 500;

const double defaultBlur = 15.0;
const double defaultPadding = 20.0;
const double defaultPaddingContain = 12.0;
const double defaultBorderSize = 1.5;
const double defaultSizeIcon = 20.0;
const double defaultHeightButton = 45.0;
const double defaultHeightButtonIcon = 32.0;
const double defaultHeightCard = 160.0;
const double defaultHeightIndicator = 6.0;

const defaultEdge = EdgeInsets.all(defaultPadding);
const defaultEdgeContain = EdgeInsets.all(defaultPaddingContain);
const defaultHorizontalEdge = EdgeInsets.symmetric(horizontal: defaultPadding);
const defaultVerticalEdge = EdgeInsets.symmetric(vertical: defaultPadding);
const defaultInputEdge = EdgeInsets.symmetric(
  horizontal: defaultPadding,
  vertical: defaultPaddingContain,
);
var defaultBoxShadow = BoxShadow(
  color: black.withOpacity(0.25),
  blurRadius: 5,
  offset: const Offset(0, 3),
);
var defaultBorderIconButton = const LinearGradient(
  begin: Alignment(0.0, -0.5),
  end: Alignment(1.0, 1.0),
  colors: [
    white,
    gray,
    // black.withOpacity(0.2),
  ],
);
var defaultLinearButton = const LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Color.fromRGBO(61, 139, 231, 1),
    Color.fromRGBO(5, 93, 215, 1),
    Color.fromRGBO(5, 93, 215, 1),
    Color.fromRGBO(5, 93, 215, 1),
  ],
);