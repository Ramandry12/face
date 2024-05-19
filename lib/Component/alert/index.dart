import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AlertGlobal extends StatelessWidget {
  final String? title;
  final int? titleLine;
  final bool? isDisableTitle;
  final String? desc;
  final bool isBahasaIndo;
  final bool isDark;
  final bool? isDisablePress;
  final Function? onPress;
  final String? labelPress;
  final bool? disablePressPop;
  final Function? onCatch;
  final String? labelCatch;
  final Color? colorCatch;
  final bool? enableBack;
  final bool? isColumnButton;
  final Widget? child;

  const AlertGlobal({
    Key? key,
    this.title,
    this.titleLine = 1,
    this.isDisableTitle = false,
    this.desc,
    this.isDisablePress = false,
    this.onPress,
    this.labelPress,
    this.disablePressPop = true,
    this.onCatch,
    this.labelCatch,
    this.colorCatch,
    required this.isDark,
    required this.isBahasaIndo,
    this.enableBack = true,
    this.isColumnButton = false,
    this.child,
  }) : super(key: key);

  void onFuncPress(context) {
    if (disablePressPop!) Navigator.of(context).pop();
    if (onPress != null) onPress!();
  }

  void onFuncCatch(context) {
    Navigator.of(context).pop();
    if (onCatch != null) onCatch!();
  }

  @override
  Widget build(BuildContext context) {
    final onTitle = title ?? (isBahasaIndo ? LabelsEN.title_btn_info : LabelsEN.title_btn_info) ;
    final onDesc = desc ?? "";
    final onLabelPress = labelPress ?? (isBahasaIndo ? LabelsEN.label_btn_next : LabelsEN.label_btn_next);
    final onLabelCatch = labelCatch ??
        (onPress != null
            ? (isBahasaIndo ? LabelsEN.label_btn_back : LabelsEN.label_btn_back)
            : (isBahasaIndo ? LabelsEN.title_btn_close : LabelsEN.title_btn_close)
        );
    final onColorCatch = onPress != null ? colorCatch ?? white : basic;
    final onColorFontCatch = onPress != null ? colorCatch ?? black2 : white;
    final onWeightFontCatch = onPress != null ? FontWeight.w500 : FontWeight.w700;
    final onDisablePress = isDisablePress!
        ? null
        : onPress != null
        ? <Widget>[
      Column(
        children: <Widget>[
          if (isColumnButton! == false)
            Row(
              children: <Widget>[
                const SizedBox(width: 10),
                Expanded(
                  child: ButtonPinchText(
                    onPressed: () => onFuncCatch(context),
                    label: onLabelCatch,
                    boxColor: onColorCatch,
                    fontColor: onColorFontCatch,
                    fontWeight: onWeightFontCatch,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ButtonPinchText(
                    onPressed: () => onFuncPress(context),
                    label: onLabelPress,
                    fontColor: white,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          if (isColumnButton! == true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  ButtonPinchText(
                    onPressed: () => onFuncPress(context),
                    label: onLabelPress,
                    fontColor: white,
                    fontSize: 15.0,
                  ),
                  const SizedBox(height: 10),
                  ButtonPinchText(
                    onPressed: () => onFuncCatch(context),
                    label: onLabelCatch,
                    boxColor: onColorCatch,
                    fontColor: onColorFontCatch,
                    fontWeight: onWeightFontCatch,
                    fontSize: 15.0,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
        ],
      ),
    ]
        : <Widget>[
      Padding(
        padding: const EdgeInsets.all(10),
        child: ButtonPinchText(
          onPressed: () => onFuncCatch(context),
          label: onLabelCatch,
          boxColor: onColorCatch,
          fontColor: onColorFontCatch,
          fontWeight: onWeightFontCatch,
          fontSize: 15.0,
        ),
      ),
    ];

    return WillPopScope(
      onWillPop: () async => enableBack!,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            primary: false,
            toolbarHeight: 0,
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            backgroundColor: transparent,
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: isDark ? white.withOpacity(0.25) : black.withOpacity(0.5),
          body: AlertDialog(
            backgroundColor: isDark ? black2 : white,
            title: isDisableTitle!
                ? null
                : Text(
              onTitle,
              style: Helpers.font1(16.0, isDark ? white : black, FontWeight.w500),
              maxLines: titleLine,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: child ??
                  ListBody(
                    children: <Widget>[
                      if (onDesc != "")
                        Text(
                          onDesc,
                          style: Helpers.font1(14.0, isDark ? white : black, FontWeight.w300),
                          textAlign: TextAlign.center,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
            ),
            actions: onDisablePress,
          ),
        ),
      ),
    );
  }
}

class AlertLoading extends StatelessWidget {
  final bool? enableBack;
  final Function? onCatch;
  final String? labelCatch;
  final bool isBahasaIndo;
  final bool isDark;

  const AlertLoading({
    Key? key,
    this.enableBack = false,
    this.onCatch,
    this.labelCatch,
    required this.isDark,
    required this.isBahasaIndo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onLabelCatch = labelCatch ?? (isBahasaIndo ? LabelsID.title_btn_close : LabelsEN.title_btn_close);

    return WillPopScope(
      onWillPop: () async => enableBack!,
      child: Scaffold(
        appBar: AppBar(
          primary: false,
          toolbarHeight: 0,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: isDark ? white.withOpacity(0.25) : transparent,
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: black.withOpacity(0.5),
        body: AlertDialog(
          backgroundColor: isDark ? black2 : white,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Text(
                  (isBahasaIndo ? LabelsID.title_btn_loading : LabelsEN.title_btn_loading),
                  style: Helpers.font1(20, isDark ? white : black.withOpacity(.6), FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                width: 50.0,
                height: 50.0,
                child: LoadingIndicator(
                    indicatorType: Indicator.ballPulse, /// Required, The loading type of the widget
                    colors: [basic],       /// Optional, The color collections
                    //strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
                    //backgroundColor: Colors.black,      /// Optional, Background of the widget
                    //pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
                ),
              ),
            ],
          ),
          actions: enableBack!
              ? <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: ButtonPinchText(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onCatch != null) onCatch!();
                },
                label: onLabelCatch,
                boxColor: basic,
                fontSize: 15.0,
              ),
            ),
          ]
              : null,
        ),
      ),
    );
  }
}

class PopUpMenu extends StatelessWidget {
  final bool isBahasaIndo;
  final bool isDark;
  final context;

  const PopUpMenu({
    Key? key,
    required this.isDark,
    required this.isBahasaIndo,
    required this.context,
  }) : super(key: key);


  void onNavigate(pages, parsingData) {
    Navigator.of(context).pop();
    Navigator.pushReplacementNamed(context, pages, arguments: parsingData);
  }
  void logoutAkun() async{
    Helpers.showAlert(
      context,
      AlertGlobal(
        isDark: isDark,
        isBahasaIndo: isBahasaIndo,
        labelPress: isBahasaIndo ? LabelsID.label_yes : LabelsEN.label_yes,
        onPress: (){
          StateManager stateManager = StateManager();
          stateManager.setLogoutSession();
          onNavigate("/Login", "");
        },
        onCatch: (){},
        labelCatch: isBahasaIndo ? LabelsID.label_tidak : LabelsEN.label_tidak,
        desc: isBahasaIndo ? LabelsID.labelAlertExit : LabelsEN.labelAlertExit,
        enableBack: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var widthCard = defaultPadding * 5;
    var heightCard = defaultPadding * 5.4;
    return WillPopScope(
      onWillPop: () async => true,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Scaffold(
          appBar: AppBar(
            primary: false,
            toolbarHeight: 0,
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            backgroundColor: transparent,
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: isDark ? white : black.withOpacity(0.5),
          body: AlertDialog(
            backgroundColor: isDark ? black2 : white,
            alignment: Alignment.topRight,
            title:Text(
              "App Menu",
              style: Helpers.font1(15.0, isDark ? white : black, FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
            content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonPinch(
                          onPressed: () => onNavigate("/Home", ""),
                          boxColor: transparent,
                          child: Container(
                            width: widthCard,
                            height: heightCard,
                            decoration: BoxDecoration(
                              borderRadius: Helpers.onRadius(1, defaultPadding),
                              color: isDark ? black2 : white,
                              boxShadow: [
                                BoxShadow(
                                  color: isDark ? white.withOpacity(0.3) : black.withOpacity(0.15),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home_outlined,
                                  size: widthCard * 0.4,
                                  color: gray,
                                ),
                                Text(
                                  "Home",
                                  style: Helpers.font1(15.0, isDark ? white : black, FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        ButtonPinch(
                          onPressed: () => onNavigate("/Search", ""),
                          boxColor: transparent,
                          child: Container(
                            width: widthCard,
                            height: heightCard,
                            decoration: BoxDecoration(
                              borderRadius: Helpers.onRadius(1, defaultPadding),
                              color: isDark ? black2 : white,
                              boxShadow: [
                                BoxShadow(
                                  color: isDark ? white.withOpacity(0.3) : black.withOpacity(0.15),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_outlined,
                                  size: widthCard * 0.4,
                                  color: gray,
                                ),
                                Text(
                                  "Search",
                                  style: Helpers.font1(15.0, isDark ? white : black, FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonPinch(
                          onPressed: () => onNavigate("/Stats", ""),
                          boxColor: transparent,
                          child: Container(
                            width: widthCard,
                            height: heightCard,
                            decoration: BoxDecoration(
                              borderRadius: Helpers.onRadius(1, defaultPadding),
                              color: isDark ? black2 : white,
                              boxShadow: [
                                BoxShadow(
                                  color: isDark ? white.withOpacity(0.3) : black.withOpacity(0.15),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cases_outlined,
                                  size: widthCard * 0.4,
                                  color: gray,
                                ),
                                Text(
                                  "Case",
                                  style: Helpers.font1(15.0, isDark ? white : black, FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        ButtonPinch(
                          onPressed: () => onNavigate("/Profile", ""),
                          boxColor: transparent,
                          child:  Container(
                            width: widthCard,
                            height: heightCard,
                            decoration: BoxDecoration(
                              borderRadius: Helpers.onRadius(1, defaultPadding),
                              color: isDark ? black2 : white,
                              boxShadow: [
                                BoxShadow(
                                  color: isDark ? white.withOpacity(0.3) : black.withOpacity(0.15),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: widthCard * 0.4,
                                  color: gray,
                                ),
                                Text(
                                  "Profile",
                                  style: Helpers.font1(15.0, isDark ? white : black, FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    ButtonPinch(
                        onPressed: ()=> logoutAkun(),
                        boxColor: transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.power_settings_new,size: defaultSizeIcon,color: gray,),
                            const SizedBox(
                              width: defaultPadding/2,
                            ),
                            Text(
                              "Logout",
                              style: Helpers.font1(15.0,
                                  isDark ? gray : black2, FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        )
                    ),
                  ],
                )
            ),
            actions: null,
          ),
        ),
      ),
    );
  }
}