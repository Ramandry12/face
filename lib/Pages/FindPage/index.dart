import 'dart:io';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindPageScreen extends StatefulWidget {
  const FindPageScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FindPageScreen> createState() => FindPageScreenState();
}

class FindPageScreenState extends State<FindPageScreen> {
  final formKeys = GlobalKey<FormState>();
  var keyHeadView = GlobalKey();
  var keyBottomView = GlobalKey();
  Size? sizeHeadView;
  Size? sizeBottomView;
  bool isDark = false;
  bool isBahasaIndo = true;
  String token = "";
  String type = "";
  File? image_;
  bool showSpinner = false;
  String valData = "";

  List searchByNik = [
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.number,
      "titleID": "Atau Gunakan ID",
      "titleEN": "Or Using ID",
      "hintID": LabelsID.hintEmail,
      "hintEN": LabelsEN.hintEmail,
    },
  ];

  List itemGender = [
    {
      "label": "Inafis",
      "value": "Inafis",
    },
  ];

  Widget searchNik(isDark, isBahasaIndo) {
    var screenWidth = (MediaQuery.of(context).size.width) - defaultPadding * 2;
    return Form(
        key: formKeys,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: searchByNik.length,
            itemBuilder: (context, index) {
              var inputForm = searchByNik[index];
              bool? isObscure = inputForm["isObscure"];
              var indexTerakhir = searchByNik.length - 1;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldDefault(
                    isDark: isDark,
                    title: isBahasaIndo
                        ? inputForm["titleID"]
                        : inputForm["titleEN"],
                    hintText: isBahasaIndo
                        ? inputForm["hintID"]
                        : inputForm["hintEN"],
                    enabled: image_ != null ? false : true,
                    maxLength: 16,
                    inputType: inputForm["keyboardType"],
                    isObscure: isObscure ?? false,
                    inputController: inputForm["inpController"],
                    validator: (value) {
                      if (Helpers.stringValidate(value) == '') {
                        return isBahasaIndo
                            ? inputForm["errorMsgID"]
                            : inputForm["errorMsgEN"];
                      }
                      return null;
                    },
                  ),
                  ModalSearch(
                    label: isBahasaIndo
                        ? LabelsID.labelDataSource
                        : LabelsEN.labelDataSource,
                    isDark: isDark,
                    hintTitle: isBahasaIndo
                        ? LabelsID.labelSelectDataSource
                        : LabelsEN.labelSelectDataSource,
                    fit: FlexFit.loose,
                    items: itemGender,
                    onChanged: (val) {
                      setState(() {
                        valData = val;
                      });
                    },
                    selectedItem: valData,
                    showSearchBox: false,
                    typePop: "menu",
                    itemKey: "value",
                    itemLabel: "label",
                    enableReset: false,
                    validator: (value) {
                      if (Helpers.stringValidate(value) == null) {
                        return isBahasaIndo
                            ? LabelsID.errorMessage
                            : LabelsEN.errorMessage;
                      }
                      return null;
                    },
                  ),
                ],
              );
            }));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        var arguments = (ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{}) as Map;
        setState(() {
          sizeHeadView = Helpers.getBoxSize(keyHeadView.currentContext!);
          sizeBottomView = Helpers.getBoxSize(keyBottomView.currentContext!);
          type = arguments["tipe"];
          image_ = arguments["image"];
        });
      }
    });
    setStateManager();
    super.initState();
  }

  //Default Function
  void goBack() {
    Navigator.pop(context);
  }

  void setStateManager() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('IS_DARK') ?? false;
      isBahasaIndo = prefs.getBool('IS_BAHASA') ?? true;
      token = prefs.getString('TOKEN') ?? '';
    });
  }

  Future<void> onGallery(context) async {
    XFile? image = await Helpers.onGetGallery(context, isBahasaIndo, isDark);
    if (image == null) return;
    File file = File(image.path);
    setState(() {
      image_ = file;
      print("imageeeeeee $image_");
    });
  }

  Future<void> onCamera(context) async {
    XFile? image = await Helpers.onGetCamera(context, isBahasaIndo, isDark);
    if (image == null) return;
    File file = File(image.path);
    setState(() {
      image_ = file;
      print("imageeeeeee $image_");
    });
  }

  void bottomSheetPilihGambar() async {
    bottomSheetDialog(
        context,
        isDark,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            MainButtonIcon(
              onPressed: () {
                Navigator.of(context).pop();
                onGallery(context);
              },
              iconButton: Entypo.picture,
              label: "Pilih dari galeri",
              fontStyle: Helpers.font1(15.0, white, FontWeight.w400),
            ),
          ],
        ));
  }

  void onNavigate(pages, parsingData) {
    Navigator.pushNamed(context, pages, arguments: parsingData);
  }

  void onPressedCallback() {
    String searchNik = searchByNik[0]["inpController"].text;
    // if (image_ != null && searchNik == "") {
    //   onNavigate('/FindResult',
    //       {"tipe": "FindResult", "image": image_, "searchNik": searchNik});
    // } else if (image_ == null && searchNik != "") {
    //   onNavigate('/FindResult',
    //       {"tipe": "FindResult", "image": null, "searchNik": searchNik});
    // } else {
    //   Helpers.viewToast("Silahkan Pilih Gambar Atau NIK", 3);
    // }
    if (image_ == null && searchNik == "") {
      Helpers.viewToast("Silahkan Pilih Gambar Atau NIK", 3);
    } else {
      onNavigate('/FindResult', {
        "tipe": "FindResult",
        "image": image_,
        "searchNik": searchNik,
        "token": token
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var spaceBar = Helpers.onSpaceBar(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;
    var heightMenu = screenHeight - (sizeHeadView?.height ?? 0);
    var fontColor = isDark ? white : black;
    var containerBottom = isDark ? black2 : white;
    return Background(
        isDarkTheme: isDark,
        isShowSpinner: showSpinner,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarLogo(
                    keyAppBar: keyHeadView,
                    isDark: isDark,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonPinch(
                            onPressed: goBack,
                            boxColor: transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: defaultSizeIcon,
                                  color: black2,
                                ),
                                const SizedBox(
                                  width: defaultPadding / 2,
                                ),
                                Text(
                                  isBahasaIndo
                                      ? LabelsID.label_btn_back
                                      : LabelsEN.label_btn_back,
                                  style: Helpers.font1(15.0,
                                      isDark ? gray : black2, FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            )),
                        Text(
                          type == "findOne"
                              ? isBahasaIndo
                                  ? LabelsID.labelCariSatu
                                  : LabelsEN.labelCariSatu
                              : isBahasaIndo
                                  ? LabelsID.labelCariBeberapa
                                  : LabelsEN.labelCariBeberapa,
                          style: Helpers.font1(
                              14.0, isDark ? gray : black2, FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: screenWidth,
                    height: heightMenu,
                    padding: const EdgeInsets.all(0.0),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ButtonPinch(
                            onPressed: () {
                              if (searchByNik[0]["inpController"].text == "") {
                                print(searchByNik[0]["inpController"].text);
                                bottomSheetPilihGambar();
                              }
                            },
                            scale: 0.95,
                            boxColor: transparent,
                            isShadow: false,
                            isBorder: false,
                            enable: true,
                            paddingChild: const EdgeInsets.all(0.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  isDark
                                      ? 'assets/img/bgImage_dark.png'
                                      : 'assets/img/bgImage_light.png',
                                  width: screenWidth - defaultPadding * 2,
                                  height: screenWidth - defaultPadding * 2,
                                  fit: BoxFit.contain,
                                  gaplessPlayback: true,
                                  filterQuality: FilterQuality.medium,
                                ),
                                Image.asset(
                                  isDark
                                      ? 'assets/img/img_choose_dark.png'
                                      : 'assets/img/img_choose_light.png',
                                  width: (screenWidth - defaultPadding * 2) / 2,
                                  height:
                                      (screenWidth - defaultPadding * 2) / 4,
                                  fit: BoxFit.contain,
                                  gaplessPlayback: true,
                                  filterQuality: FilterQuality.medium,
                                ),
                                if (image_ != null)
                                  Image.file(
                                    image_!,
                                    width: screenWidth - defaultPadding * 5,
                                    height: screenWidth - defaultPadding * 3,
                                    fit: BoxFit.contain,
                                    gaplessPlayback: true,
                                    filterQuality: FilterQuality.medium,
                                  ),
                              ],
                            ),
                          ),
                          Container(
                              width: screenWidth,
                              height: screenHeight,
                              padding: const EdgeInsets.all(defaultPadding),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  searchNik(isDark, isBahasaIndo),
                                  const SizedBox(
                                    height: defaultPadding * 2,
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  key: keyBottomView,
                  width: screenWidth,
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    borderRadius: Helpers.onRadius(3, defaultPadding),
                    color: containerBottom,
                    boxShadow: [
                      BoxShadow(
                        color: black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: MainButtonText(
                    onPressed: onPressedCallback,
                    label: isBahasaIndo
                        ? LabelsID.labelProses
                        : LabelsEN.labelProses,
                    fontStyle: Helpers.font1(15.0, white, FontWeight.w600),
                  ),
                )),
          ],
        ));
  }
}
