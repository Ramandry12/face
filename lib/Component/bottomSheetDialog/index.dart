import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';

void bottomSheetDialog(
    BuildContext context,
    bool isDark,
    Widget child,
    ) {
  var screenWidth = MediaQuery.of(context).size.width;
  var radiusTop = Helpers.onRadius(3, defaultPadding);
  showModalBottomSheet<void>(
    isScrollControlled: true,
    enableDrag: true,
    context: context,
    barrierColor: black.withOpacity(0.5),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(defaultPadding))),
    builder: (BuildContext context) {
      return Wrap(
        children: [
          Container(
            width: screenWidth,
            decoration: BoxDecoration(
              borderRadius: radiusTop,
              color: isDark ? black2 : white,
              boxShadow: [
                BoxShadow(
                  color: isDark ? white.withOpacity(0.3) : black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Stack(
              children: [
                Container(
                  width: screenWidth,
                  padding: const EdgeInsets.all(defaultPadding),
                  child: child,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: IndicatorModalChild(
                    borderRadius: Helpers.onRadius(3, defaultPadding),
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
