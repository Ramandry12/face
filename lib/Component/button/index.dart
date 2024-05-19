import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
class ButtonPinch extends StatefulWidget {
  final VoidCallback onPressed;
  final double? radius;
  final BorderRadiusGeometry? onRadius;
  final Color? boxColor;
  final bool? isBorder;
  final bool? isShadow;
  final List<BoxShadow>? boxShadowStyle;
  final bool? enable;
  final double? scale;
  final EdgeInsets? paddingChild;
  final EdgeInsets? marginChild;
  final Widget? child;

  const ButtonPinch({
    Key? key,
    required this.onPressed,
    this.radius,
    this.onRadius,
    this.boxColor = blackLow,
    this.isBorder = false,
    this.isShadow = false,
    this.boxShadowStyle,
    this.enable = true,
    this.scale = 0.95,
    this.paddingChild,
    this.marginChild,
    this.child,
  }) : super(key: key);

  @override
  State<ButtonPinch> createState() => ButtonPinchState();
}
class ButtonPinchState extends State<ButtonPinch> {
  double scale = 1.0;
  bool absorb = true;
  int times = 100;

  void onStart() {
    if (widget.enable == true) {
      setState(() {
        scale = widget.scale!;
        absorb = false;
      });
      Helpers.onWaiting(onEnd, times);
    }
  }

  void onEnd() {
    setState(() {
      scale = 1.0;
    });
    Helpers.onWaiting(onAction, times);
  }

  void onAction() {
    FocusManager.instance.primaryFocus?.unfocus();
    widget.onPressed();
    setState(() {
      absorb = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var onViewRadius = widget.radius ?? 15.0;
    var onShadow = widget.isShadow!
        ? widget.boxShadowStyle ?? [defaultBoxShadow]
        : null;

    return AnimatedScale(
      scale: scale,
      duration: Duration(milliseconds: times),
      child: Container(
        decoration: BoxDecoration(
          gradient: widget.isBorder! ? defaultBorderIconButton : null,
          borderRadius: widget.onRadius ?? Helpers.onRadius(1, onViewRadius),
          boxShadow: onShadow,
        ),
        padding: widget.isBorder! ? const EdgeInsets.all(defaultBorderSize) : null ,
        child: Container(
          decoration: BoxDecoration(
            color: widget.boxColor,
            borderRadius: widget.onRadius ?? Helpers.onRadius(1, onViewRadius),
          ),
          child: Material(
            color: transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: widget.boxColor,
                borderRadius: widget.onRadius ?? Helpers.onRadius(1, onViewRadius),
              ),
              child: AbsorbPointer(
                absorbing: !absorb,
                child: InkWell(
                  splashColor: widget.enable == false ? transparent : black.withOpacity(0.1),
                  highlightColor: transparent,
                  borderRadius: widget.onRadius ?? Helpers.onRadius(1, onViewRadius),
                  onTap: onStart,
                  enableFeedback: false,
                  child: Container(
                    padding: widget.paddingChild ?? const EdgeInsets.all(0),
                    margin: widget.marginChild ?? const EdgeInsets.all(0),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class ButtonPinchText extends StatelessWidget {
  final VoidCallback onPressed;
  final double? radius;
  final Color? boxColor;
  final bool? isShadow;
  final bool? isBorder;
  final double? scale;
  final bool? enable;
  final EdgeInsets? paddingChild;
  final double? height;
  final double? width;
  final String? label;
  final FontWeight? fontWeight;
  final Color? fontColor;
  final double? fontSize;

  const ButtonPinchText({
    Key? key,
    required this.onPressed,
    this.radius = 15.0,
    this.boxColor = basic,
    this.isShadow = true,
    this.isBorder = false,
    this.scale = 0.95,
    this.enable = true,
    this.paddingChild = const EdgeInsets.all(0),
    this.height = defaultHeightButton,
    this.width = double.infinity,
    this.label,
    this.fontWeight = FontWeight.w700,
    this.fontColor = black,
    this.fontSize = 15.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonPinch(
      onPressed: onPressed,
      radius: radius,
      boxColor: boxColor,
      isShadow: isShadow,
      isBorder: isBorder,
      scale: scale,
      enable: enable,
      paddingChild: paddingChild,
      child: Container(
        height: height! - (boxColor == white ? 3.0 : 0.0),
        width: width! - (boxColor == white ? 3.0 : 0.0),
        alignment: Alignment.center,
        child: Text(
          label.toString(),
          style: Helpers.font1(fontSize!, fontColor, fontWeight),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
class ButtonPinchIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final double? radius;
  final Color? boxColor;
  final bool? isShadow;
  final bool? isBorder;
  final double? scale;
  final bool? enable;
  final EdgeInsets? paddingChild;
  final double? height;
  final double? width;
  final bool? isIcon;
  final String? imageData;
  final IconData? iconData;
  final double? iconSize;
  final Color? iconColor;

  const ButtonPinchIcon({
    Key? key,
    required this.onPressed,
    this.radius = 8.0,
    this.boxColor = blackLow,
    this.isShadow = true,
    this.isBorder = true,
    this.scale = 0.95,
    this.enable = true,
    this.paddingChild = const EdgeInsets.all(0),
    this.height = defaultHeightButtonIcon,
    this.width = defaultHeightButtonIcon,
    this.isIcon = true,
    this.imageData = "assets/mif/MIF_Icon.png",
    this.iconData,
    this.iconSize = defaultSizeIcon,
    this.iconColor = black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonPinch(
      onPressed: onPressed,
      radius: radius,
      boxColor: boxColor,
      isShadow: isShadow,
      isBorder: isBorder,
      scale: scale,
      enable: enable,
      paddingChild: paddingChild,
      child: Container(
        height: height! - (boxColor == white ? 3.0 : 0.0),
        width: width! - (boxColor == white ? 3.0 : 0.0),
        alignment: Alignment.center,
        child: isIcon!
            ? Icon(
          iconData,
          size: iconSize,
          color: iconColor,
        )
            : Image.asset(
          imageData!,
          height: iconSize,
          width: iconSize,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}

class MainButtonText extends StatelessWidget{
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final String? label;
  final fontStyle;
  final Color? bgColor;
  const MainButtonText({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.fontStyle,
    this.height = defaultHeightButton,
    this.width = double.infinity,
    this.bgColor = basic,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ButtonPinch(
      onPressed:onPressed,
      scale: 0.95,
      boxColor: transparent,
      isShadow: false,
      isBorder: false,
      enable: true,
      paddingChild: const EdgeInsets.all(0.0),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: Helpers.onRadius(1, defaultPadding),
          border: Border.all(color: basic, width: 2.0),
          color: bgColor,
        ),
        child: Text(
          label!,
          style: fontStyle,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}
class MainButtonIcon extends StatelessWidget{
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final String? label;
  final fontStyle;
  final IconData iconButton;
  const MainButtonIcon({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.fontStyle,
    required this.iconButton,
    this.height = defaultHeightButton,
    this.width = double.infinity,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ButtonPinch(
      onPressed:onPressed,
      scale: 0.95,
      boxColor: transparent,
      isShadow: false,
      isBorder: false,
      enable: true,
      paddingChild: const EdgeInsets.all(0.0),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: Helpers.onRadius(1, defaultPadding),
          color: basic,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconButton,
              size: defaultSizeIcon ,
              color: white,
            ),
            const SizedBox(
              width: defaultPadding/2,
            ),
            Text(
              label!,
              style: fontStyle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}
