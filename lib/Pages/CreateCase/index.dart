import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCaseScreen extends StatefulWidget {
  const CreateCaseScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateCaseScreen> createState() => CreateCaseScreenState();
}

class CreateCaseScreenState extends State<CreateCaseScreen> {
  final formKeys = GlobalKey<FormState>();
  final controller1 = TextEditingController();
  final controller1_1 = TextEditingController();
  final controller1_date = TextEditingController();
  final controller1_location = TextEditingController();
  final controller1_PostalCode = TextEditingController();

  final controller2 = TextEditingController();
  final controller2_2 = TextEditingController();
  final controller2_date = TextEditingController();
  final controller2_place = TextEditingController();
  final controller2_alias = TextEditingController();
  final controller2_address = TextEditingController();
  final controller2_father = TextEditingController();
  final controller2_bodyH = TextEditingController();
  final controller2_bodyW = TextEditingController();
  final controller2_tatto = TextEditingController();
  final controller2_deformed = TextEditingController();
  final controller2_chapter = TextEditingController();
  final controller2_desc = TextEditingController();

  String token = "";
  var keyHeadView = GlobalKey();
  var keyBottomView = GlobalKey();
  Size? sizeHeadView;
  Size? sizeBottomView;
  bool isDark = false;
  bool isBahasaIndo = true;
  String type = "";
  int selectedTab = 0;
  int pageTab = 1;
  String labelTab = "";
  String valCase = "";
  String valCrime = "";
  String valCaseStatus = "";
  String valProvince = "";
  String valCity = "";
  String valDateSource = "";
  String valReligion = "";
  String valFaceShape = "";
  String valBodyShape = "";
  String valHeadShape = "";
  String valHairType = "";
  String valForeheadShape = "";
  String valNoseType = "";
  String valLipShape = "";
  String valHairColor = "";
  String valEyeColor = "";
  String valEthnicity = "";
  String valChinShape = "";
  String valEarShape = "";
  String valSkinColor = "";
  String valBloodType = "";
  String valEyeDisord = "";
  String valToothShape = "";
  String selectedOpsGender = "";
  double? sizeScWidth;
  List<Map<String, dynamic>> dataCase = [];
  int casesId = 0;

  List caseLabelList = [
    {"titleID": LabelsID.labelCaseInfo, "titleEN": LabelsEN.labelCaseInfo},
    {"titleID": "Informasi Sasaran", "titleEN": "Target Information"},
    {"titleID": "Informasi AK23", "titleEN": "AK23 Information"},
  ];

  List itemCase = [];
  List itemCrime = [];
  List itemCaseStatus = [];
  List itemProvince = [];
  List itemCity = [
    {
      "label": "JAKARTA TIMUR",
      "value": "jkt_timur",
    },
    {
      "label": "DEPOK",
      "value": "depok",
    },
    {
      "label": "TEGAL",
      "value": "tegal",
    }
  ];
  List itemReligions = [];
  List itemFaceShapes = [];
  List itemBodyShapes = [];
  List itemHeadShapes = [];
  List itemHairTypes = [];
  List itemForeheads = [];
  List itemNoseTypes = [];
  List itemLipsTypes = [];
  List itemHairColors = [];
  List itemEyeColors = [];
  List itemEthnicities = [];
  List itemChinTypes = [];
  List itemEarTypes = [];
  List itemSkinColors = [];
  List itemBloodTypes = [];
  List itemEyeProblems = [];
  List itemTeethTypes = [];
  List<dynamic> resultDataList = [];
  List<dynamic> resultDataNik = [];
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (ModalRoute.of(context)?.settings.arguments != "") {
          var arguments = (ModalRoute.of(context)?.settings.arguments ??
              <String, dynamic>{}) as Map;

          setState(() {
            type = arguments["tipe"];
            resultDataList = arguments["response"] ?? [];
            resultDataNik = arguments["response1"] ?? [];
            print(resultDataNik);
          });
        }
      }
      setStateManager();
    });
  }

  //Default Function
  void goBack() {
    Navigator.pop(context);
  }

  void onNavigate(pages, parsingData) {
    Navigator.pushNamed(context, pages, arguments: parsingData);
  }

  void setStateManager() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('IS_DARK') ?? false;
      isBahasaIndo = prefs.getBool('IS_BAHASA') ?? true;
      token = prefs.getString('TOKEN') ?? '';
      log("prefs token : $token");
      caseTypeServices();
      caseSubTypesServices();
      caseStatusesServices();
      provinceServices();
      religionsServices();
      faceShapesServices();
      bodyShapesServices();
      headShapesServices();
      hairTypesServices();
      foreheadsServices();
      noseTypesServices();
      lipsTypesServices();
      hairColorsServices();
      eyeColorsServices();
      ethnicitiesServices();
      chinTypesServices();
      earTypesServices();
      skinColorsServices();
      bloodTypesServices();
      eyeProblemsServices();
      teethTypesServices();
    });
  }

  Widget pageOne() {
    return Form(
      key: formKeys,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo
                  ? LabelsID.labelTitleInput
                  : LabelsEN.labelTitleInput,
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller1,
              textCapital: TextCapitalization.words,
            ),
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo
                  ? LabelsID.labelInvestigator
                  : LabelsEN.labelInvestigator,
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller1_1,
              textCapital: TextCapitalization.words,
            ),
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelCaseType
                  : LabelsEN.labelCaseType,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectType
                  : LabelsEN.labelSelectType,
              fit: FlexFit.loose,
              items: itemCase,
              onChanged: (val) {
                setState(() {
                  valCase = val;
                });
              },
              selectedItem: valCase,
              showSearchBox: true,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelCrimeType
                  : LabelsEN.labelCrimeType,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectType
                  : LabelsEN.labelSelectType,
              fit: FlexFit.loose,
              items: itemCrime,
              onChanged: (val) {
                setState(() {
                  valCrime = val;
                });
              },
              selectedItem: valCrime,
              showSearchBox: true,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelCaseStatus
                  : LabelsEN.labelCaseStatus,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectStatus
                  : LabelsEN.labelSelectStatus,
              fit: FlexFit.loose,
              items: itemCaseStatus,
              onChanged: (val) {
                setState(() {
                  valCaseStatus = val;
                });
              },
              selectedItem: valCaseStatus,
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
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo
                  ? LabelsID.labelDateInput
                  : LabelsEN.labelDateInput,
              hintText: "",
              inputController: controller1_date,
              inputType: "datePicker",
              prefixIcon: Icon(
                Entypo.calendar,
                size: defaultSizeIcon,
                color: isDark ? gray.withOpacity(0.5) : basic.withOpacity(0.5),
              ),
              suffixIcon: null,
            ),
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelProvince
                  : LabelsEN.labelProvince,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectProvince
                  : LabelsEN.labelSelectProvince,
              fit: FlexFit.loose,
              items: itemProvince,
              onChanged: (val) {
                setState(() {
                  valProvince = val;
                });
              },
              selectedItem: valProvince,
              showSearchBox: true,
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
            ModalSearch(
              label: isBahasaIndo ? LabelsID.labelCity : LabelsEN.labelCity,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectCity
                  : LabelsEN.labelSelectCity,
              fit: FlexFit.loose,
              items: itemCity,
              onChanged: (val) {
                setState(() {
                  valCity = val;
                });
              },
              selectedItem: valCity,
              showSearchBox: true,
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
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo
                  ? LabelsID.labelLocation
                  : LabelsEN.labelLocation,
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller1_location,
              textCapital: TextCapitalization.words,
            ),
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo
                  ? LabelsID.labelPostalCode
                  : LabelsEN.labelPostalCode,
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller1_PostalCode,
              inputType: TextInputType.number,
              maxLength: 5,
            ),
            SizedBox(
              height: 10.0,
            ),
            MainButtonText(
              onPressed: submitPageCases,
              label: isBahasaIndo
                  ? LabelsID.label_btn_next
                  : LabelsEN.label_btn_next,
              fontStyle: Helpers.font1(14.0, white, FontWeight.w600),
            ),
          ]),
    );
  }

  Widget pageTwo() {
    return Form(
      key: formKeys,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldDefault(
              isDark: isDark,
              title: "NIK",
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller2,
              inputType: TextInputType.number,
              maxLength: 16,
            ),
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo
                  ? LabelsID.labelTargetName
                  : LabelsEN.labelTargetName,
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller2_2,
              textCapital: TextCapitalization.words,
            ),
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo
                  ? LabelsID.labelDetailTanggalLahir
                  : LabelsEN.labelDetailTanggalLahir,
              hintText: "",
              inputController: controller2_date,
              inputType: "datePicker",
              prefixIcon: Icon(
                Entypo.calendar,
                size: defaultSizeIcon,
                color: isDark ? gray.withOpacity(0.5) : basic.withOpacity(0.5),
              ),
              suffixIcon: null,
            ),
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo
                  ? LabelsID.labelDetailTempatLahir
                  : LabelsEN.labelDetailTempatLahir,
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller2_place,
              textCapital: TextCapitalization.words,
            ),
            Text(
              isBahasaIndo
                  ? LabelsID.labelDetailJenisKelamin
                  : LabelsEN.labelDetailJenisKelamin,
              style:
                  Helpers.font1(14.0, isDark ? gray : black2, FontWeight.w400),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                RadioButton(
                    label: "Male",
                    groupValue: selectedOpsGender,
                    value: "M",
                    onChanged: (value) {
                      setState(() {
                        selectedOpsGender = value;
                      });
                    }),
                SizedBox(width: 10.0),
                RadioButton(
                    label: "Female",
                    groupValue: selectedOpsGender,
                    value: "F",
                    onChanged: (value) {
                      setState(() {
                        selectedOpsGender = value;
                      });
                    }),
              ],
            ),
            SizedBox(
              height: 10.0,
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
              items: [],
              onChanged: (val) {
                setState(() {
                  valDateSource = val;
                });
              },
              selectedItem: valDateSource,
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
            TextFieldDefault(
              isDark: isDark,
              title: "Alias",
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller2_alias,
              textCapital: TextCapitalization.words,
            ),
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo
                  ? LabelsID.labelCurrentAddress
                  : LabelsEN.labelCurrentAddress,
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller2_address,
              textCapital: TextCapitalization.words,
              maxLines: 4,
            ),
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo
                  ? LabelsID.labelFatherName
                  : LabelsEN.labelFatherName,
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller2_father,
              textCapital: TextCapitalization.words,
            ),
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelDetailAgama
                  : LabelsEN.labelDetailAgama,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectAgama
                  : LabelsEN.labelSelectAgama,
              fit: FlexFit.loose,
              items: itemReligions,
              onChanged: (val) {
                setState(() {
                  valReligion = val;
                });
              },
              selectedItem: valReligion,
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
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo
                  ? LabelsID.labelBodyHeight
                  : LabelsEN.labelBodyHeight,
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller2_bodyH,
              inputType: TextInputType.number,
              maxLength: 3,
            ),
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo
                  ? LabelsID.labelBodyWeight
                  : LabelsEN.labelBodyWeight,
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller2_bodyW,
              inputType: TextInputType.number,
              maxLength: 3,
            ),
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo ? LabelsID.labelTatto : LabelsEN.labelTatto,
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller2_tatto,
              textCapital: TextCapitalization.words,
            ),
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo
                  ? LabelsID.labelDeformed
                  : LabelsEN.labelDeformed,
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller2_deformed,
              textCapital: TextCapitalization.words,
            ),
            TextFieldDefault(
              isDark: isDark,
              title:
                  isBahasaIndo ? LabelsID.labelChapter : LabelsEN.labelChapter,
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller2_chapter,
              textCapital: TextCapitalization.words,
            ),
            TextFieldDefault(
              isDark: isDark,
              title: isBahasaIndo
                  ? LabelsID.labelDescription
                  : LabelsEN.labelDescription,
              hintText: isBahasaIndo
                  ? LabelsID.labelSomeTextHere
                  : LabelsEN.labelSomeTextHere,
              inputController: controller2_desc,
              textCapital: TextCapitalization.words,
              maxLines: 4,
            ),
            SizedBox(
              height: 20.0,
            ),
            // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // MainButtonText(
            //   width: sizeScWidth,
            //   bgColor: Colors.white,
            //   onPressed: prevPage,
            //   label: isBahasaIndo
            //       ? LabelsID.labelPrevious
            //       : LabelsEN.labelPrevious,
            //   fontStyle: Helpers.font1(14.0, basic, FontWeight.w600),
            // ),
            MainButtonText(
              // width: sizeScWidth,
              onPressed: nextPage,
              label: isBahasaIndo
                  ? LabelsID.label_btn_next
                  : LabelsEN.label_btn_next,
              fontStyle: Helpers.font1(14.0, white, FontWeight.w600),
            ),
            // ]),
          ]),
    );
  }

  Widget pageThree() {
    return Form(
      key: formKeys,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelFaceShape
                  : LabelsEN.labelFaceShape,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectShape
                  : LabelsEN.labelSelectShape,
              fit: FlexFit.loose,
              items: itemFaceShapes,
              onChanged: (val) {
                setState(() {
                  valFaceShape = val;
                });
              },
              selectedItem: valFaceShape,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelBodyShape
                  : LabelsEN.labelBodyShape,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectShape
                  : LabelsEN.labelSelectShape,
              fit: FlexFit.loose,
              items: itemBodyShapes,
              onChanged: (val) {
                setState(() {
                  valBodyShape = val;
                });
              },
              selectedItem: valBodyShape,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelHeadShape
                  : LabelsEN.labelHeadShape,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectShape
                  : LabelsEN.labelSelectShape,
              fit: FlexFit.loose,
              items: itemHeadShapes,
              onChanged: (val) {
                setState(() {
                  valHeadShape = val;
                });
              },
              selectedItem: valHeadShape,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelHairType
                  : LabelsEN.labelHairType,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectType
                  : LabelsEN.labelSelectType,
              fit: FlexFit.loose,
              items: itemHairTypes,
              onChanged: (val) {
                setState(() {
                  valHairType = val;
                });
              },
              selectedItem: valHairType,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelForeheadShape
                  : LabelsEN.labelForeheadShape,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectShape
                  : LabelsEN.labelSelectShape,
              fit: FlexFit.loose,
              items: itemForeheads,
              onChanged: (val) {
                setState(() {
                  valForeheadShape = val;
                });
              },
              selectedItem: valForeheadShape,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelNoseType
                  : LabelsEN.labelNoseType,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectType
                  : LabelsEN.labelSelectType,
              fit: FlexFit.loose,
              items: itemNoseTypes,
              onChanged: (val) {
                setState(() {
                  valNoseType = val;
                });
              },
              selectedItem: valNoseType,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelLipShape
                  : LabelsEN.labelLipShape,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectShape
                  : LabelsEN.labelSelectShape,
              fit: FlexFit.loose,
              items: itemLipsTypes,
              onChanged: (val) {
                setState(() {
                  valLipShape = val;
                });
              },
              selectedItem: valLipShape,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelHairColor
                  : LabelsEN.labelHairColor,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectColor
                  : LabelsEN.labelSelectColor,
              fit: FlexFit.loose,
              items: itemHairColors,
              onChanged: (val) {
                setState(() {
                  valHairColor = val;
                });
              },
              selectedItem: valHairColor,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelEyeColor
                  : LabelsEN.labelEyeColor,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectColor
                  : LabelsEN.labelSelectColor,
              fit: FlexFit.loose,
              items: itemEyeColors,
              onChanged: (val) {
                setState(() {
                  valEyeColor = val;
                });
              },
              selectedItem: valEyeColor,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelEthnicity
                  : LabelsEN.labelEthnicity,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectEthnicity
                  : LabelsEN.labelSelectEthnicity,
              fit: FlexFit.loose,
              items: itemEthnicities,
              onChanged: (val) {
                setState(() {
                  valEthnicity = val;
                });
              },
              selectedItem: valEthnicity,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelChinShape
                  : LabelsEN.labelChinShape,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectShape
                  : LabelsEN.labelSelectShape,
              fit: FlexFit.loose,
              items: itemChinTypes,
              onChanged: (val) {
                setState(() {
                  valChinShape = val;
                });
              },
              selectedItem: valChinShape,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelEarShape
                  : LabelsEN.labelEarShape,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectShape
                  : LabelsEN.labelSelectShape,
              fit: FlexFit.loose,
              items: itemEarTypes,
              onChanged: (val) {
                setState(() {
                  valEarShape = val;
                });
              },
              selectedItem: valEarShape,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelSkinColor
                  : LabelsEN.labelSkinColor,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectColor
                  : LabelsEN.labelSelectColor,
              fit: FlexFit.loose,
              items: itemSkinColors,
              onChanged: (val) {
                setState(() {
                  valSkinColor = val;
                });
              },
              selectedItem: valSkinColor,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelBloodType
                  : LabelsEN.labelBloodType,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectType
                  : LabelsEN.labelSelectType,
              fit: FlexFit.loose,
              items: itemBloodTypes,
              onChanged: (val) {
                setState(() {
                  valBloodType = val;
                });
              },
              selectedItem: valBloodType,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelEyeDisorders
                  : LabelsEN.labelEyeDisorders,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectIfAvail
                  : LabelsEN.labelSelectIfAvail,
              fit: FlexFit.loose,
              items: itemEyeProblems,
              onChanged: (val) {
                setState(() {
                  valEyeDisord = val;
                });
              },
              selectedItem: valEyeDisord,
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
            ModalSearch(
              label: isBahasaIndo
                  ? LabelsID.labelToothShape
                  : LabelsEN.labelToothShape,
              isDark: isDark,
              hintTitle: isBahasaIndo
                  ? LabelsID.labelSelectShape
                  : LabelsEN.labelSelectShape,
              fit: FlexFit.loose,
              items: itemTeethTypes,
              onChanged: (val) {
                setState(() {
                  valToothShape = val;
                });
              },
              selectedItem: valToothShape,
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              MainButtonText(
                width: sizeScWidth,
                bgColor: Colors.white,
                onPressed: prevPage,
                label: isBahasaIndo
                    ? LabelsID.labelPrevious
                    : LabelsEN.labelPrevious,
                fontStyle: Helpers.font1(14.0, basic, FontWeight.w600),
              ),
              MainButtonText(
                width: sizeScWidth,
                onPressed: submitPage,
                label:
                    isBahasaIndo ? LabelsID.labelSubmit : LabelsEN.labelSubmit,
                fontStyle: Helpers.font1(14.0, white, FontWeight.w600),
              ),
            ]),
          ]),
    );
  }

  void nextPage() {
    if (formKeys.currentState!.validate()) {
      selectedTab++;

      setState(() {
        MenuCaseList(
            dataCaseList: caseLabelList[selectedTab],
            isBahasaIndo: isBahasaIndo,
            isDark: isDark,
            selectedTab: selectedTab,
            index: selectedTab,
            actionTab: () {
              setState(() {
                selectedTab = selectedTab;
                pageTab = selectedTab + 1;
                labelTab = isBahasaIndo
                    ? caseLabelList[selectedTab]["titleID"]
                    : caseLabelList[selectedTab]["titleEN"];
              });
            });

        selectedTab = selectedTab;
        pageTab = selectedTab + 1;
        labelTab = isBahasaIndo
            ? caseLabelList[selectedTab]["titleID"]
            : caseLabelList[selectedTab]["titleEN"];
      });
    }
  }

  void prevPage() {
    if (formKeys.currentState!.validate()) {
      selectedTab--;

      setState(() {
        MenuCaseList(
            dataCaseList: caseLabelList[selectedTab],
            isBahasaIndo: isBahasaIndo,
            isDark: isDark,
            selectedTab: selectedTab,
            index: selectedTab,
            actionTab: () {
              setState(() {
                selectedTab = selectedTab;
                pageTab = selectedTab + 1;
                labelTab = isBahasaIndo
                    ? caseLabelList[selectedTab]["titleID"]
                    : caseLabelList[selectedTab]["titleEN"];
              });
            });

        selectedTab = selectedTab;
        pageTab = selectedTab + 1;
        labelTab = isBahasaIndo
            ? caseLabelList[selectedTab]["titleID"]
            : caseLabelList[selectedTab]["titleEN"];
      });
    }
  }

  void submitPage() {
    if (formKeys.currentState!.validate()) {
      DateTime now = DateTime.now();
      String newDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
      String pgOneDate = controller1_date.text;
      if (pgOneDate.isEmpty) {
        Helpers.viewToast(
            isBahasaIndo ? LabelsID.errorMessage : LabelsEN.errorMessage, 3);
        return;
      }
      var dateE =
          DateFormat("dd/MM/yyyy").parse(pgOneDate).toString().split(" ");
      var dates1 = dateE[0].toString().trim();

      String dateDOB = controller2_date.text;
      if (dateDOB.isEmpty) {
        Helpers.viewToast(
            isBahasaIndo ? LabelsID.errorMessage : LabelsEN.errorMessage, 3);
        return;
      }
      var datesDOB =
          DateFormat("dd/MM/yyyy").parse(dateDOB).toString().split(" ");
      var DOB = datesDOB[0].toString().trim();

      var parambody = {
        "person": {
          "dateCreated": newDate,
          "dateModified": newDate,
          "lastModifiedBy": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
          "nik": controller2.text,
          "fullName": controller2_2.text,
          "dateOfBirth": DOB,
          "placeOfBirth": controller2_place.text,
          "gender": selectedOpsGender,
          "alias": controller2_alias.text,
          "currentAddress": controller2_address.text,
          "fatherName": controller2_father.text,
          "height": controller2_bodyH.text,
          "weight": controller2_bodyW.text,
          "fatherAddress": "xxx",
          "motherName": "xxx",
          "motherAddress": "xxx",
          "spouseName": "xxx",
          "spouseAddress": "xxx",
        },
        "ak23": {
          "dateCreated": newDate,
          "dateModified": newDate,
          "lastModifiedBy": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
          "religionId": valReligion.toString(),
          "tattoo": controller2_tatto.text,
          "disability": controller2_deformed.text,
          "articleCode": controller2_chapter.text,
          "description": controller2_desc.text,
          "faceShapeId": valFaceShape.toString(),
          "bodyShapeId": valBodyShape.toString(),
          "headShapeId": valHeadShape.toString(),
          "hairTypeId": valHairType.toString(),
          "foreheadId": valForeheadShape.toString(),
          "noseTypeId": valNoseType.toString(),
          "lipsTypeId": valLipShape.toString(),
          "hairColorId": valHairColor.toString(),
          "eyeColorId": valEyeColor.toString(),
          "ethnicityId": valEthnicity.toString(),
          "chinTypeId": valChinShape.toString(),
          "earTypeId": valEarShape.toString(),
          "skinColorId": valSkinColor.toString(),
          "bloodTypeId": valBloodType.toString(),
          "eyeProblemId": valEyeDisord.toString(),
          "teethTypeId": valToothShape.toString(),
          "targetFace": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
        }
      };

      submitCaseServices(parambody);
    }
  }

  void submitPageCases() {
    if (formKeys.currentState!.validate()) {
      DateTime now = DateTime.now();
      String formattedDate = now.toString().replaceAll(" ", "T");
      String newDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
      String pgOneDate = controller1_date.text;
      if (pgOneDate.isEmpty) {
        Helpers.viewToast(
            isBahasaIndo ? LabelsID.errorMessage : LabelsEN.errorMessage, 3);
        return;
      }
      var dateE =
          DateFormat("dd/MM/yyyy").parse(pgOneDate).toString().split(" ");
      var dates1 = dateE[0].toString().trim();

      var paramBody = {
        "caseTypeId": valCase,
        "caseSubTypeId": valCrime,
        "caseStatusId": valCaseStatus,
        "dateCase": dates1,
        "provinceId": valProvince,
        "city": valCity,
        "location": controller1_location.text,
        "zipCode": controller1_PostalCode.text,
        "investigator": "xxx",
        "operator": "xxx",
        "participant": "xxx",
      };

      createCaseServices(paramBody);
      editCaseServices(paramBody);
    }
  }

  void caseTypeServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.caseTypes}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataCaseTypes = response['data']['_embedded']['caseTypes'];
        for (int i = 0; i < dataCaseTypes.length; i++) {
          itemCase.add({
            'label': dataCaseTypes[i]['name'],
            'value': dataCaseTypes[i]['id'].toString()
          });
        }
      }
    });
  }

  void caseSubTypesServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.caseSubTypes}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataCaseSubTypes = response['data']['_embedded']['caseSubTypes'];
        for (int i = 0; i < dataCaseSubTypes.length; i++) {
          itemCrime.add({
            'label': dataCaseSubTypes[i]['name'],
            'value': dataCaseSubTypes[i]['id'].toString()
          });
        }
      }
    });
  }

  void caseStatusesServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.caseStatuses}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataCaseStatuses = response['data']['_embedded']['caseStatuses'];
        for (int i = 0; i < dataCaseStatuses.length; i++) {
          itemCaseStatus.add({
            'label': dataCaseStatuses[i]['name'],
            'value': dataCaseStatuses[i]['id'].toString()
          });
        }
      }
    });
  }

  void provinceServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.provinces}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataProvinces = response['data']['_embedded']['provinces'];
        for (int i = 0; i < dataProvinces.length; i++) {
          itemProvince.add({
            'label': dataProvinces[i]['name'],
            'value': dataProvinces[i]['id'].toString()
          });
        }
      }
    });
  }

  void religionsServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.religions}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataReligions = response['data']['_embedded']['religions'];
        for (int i = 0; i < dataReligions.length; i++) {
          itemReligions.add({
            'label': dataReligions[i]['name'],
            'value': dataReligions[i]['id'].toString()
          });
        }
      }
    });
  }

  void faceShapesServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.faceShapes}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataFaceShapes = response['data']['_embedded']['faceShapes'];
        for (int i = 0; i < dataFaceShapes.length; i++) {
          itemFaceShapes.add({
            'label': dataFaceShapes[i]['name'],
            'value': dataFaceShapes[i]['id'].toString()
          });
        }
      }
    });
  }

  void bodyShapesServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.bodyShapes}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataBodyShapes = response['data']['_embedded']['bodyShapes'];
        for (int i = 0; i < dataBodyShapes.length; i++) {
          itemBodyShapes.add({
            'label': dataBodyShapes[i]['name'],
            'value': dataBodyShapes[i]['id'].toString()
          });
        }
      }
    });
  }

  void headShapesServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.headShapes}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataHeadShapes = response['data']['_embedded']['headShapes'];
        for (int i = 0; i < dataHeadShapes.length; i++) {
          itemHeadShapes.add({
            'label': dataHeadShapes[i]['name'],
            'value': dataHeadShapes[i]['id'].toString()
          });
        }
      }
    });
  }

  void hairTypesServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.hairTypes}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataHairTypes = response['data']['_embedded']['hairTypes'];
        for (int i = 0; i < dataHairTypes.length; i++) {
          itemHairTypes.add({
            'label': dataHairTypes[i]['name'],
            'value': dataHairTypes[i]['id'].toString()
          });
        }
      }
    });
  }

  void foreheadsServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.foreheads}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataForeheads = response['data']['_embedded']['foreheads'];
        for (int i = 0; i < dataForeheads.length; i++) {
          itemForeheads.add({
            'label': dataForeheads[i]['name'],
            'value': dataForeheads[i]['id'].toString()
          });
        }
      }
    });
  }

  void noseTypesServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.noseTypes}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataNoseTypes = response['data']['_embedded']['noseTypes'];
        for (int i = 0; i < dataNoseTypes.length; i++) {
          itemNoseTypes.add({
            'label': dataNoseTypes[i]['name'],
            'value': dataNoseTypes[i]['id'].toString()
          });
        }
      }
    });
  }

  void lipsTypesServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.lipsTypes}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataLipsTypes = response['data']['_embedded']['lipsTypes'];
        for (int i = 0; i < dataLipsTypes.length; i++) {
          itemLipsTypes.add({
            'label': dataLipsTypes[i]['name'],
            'value': dataLipsTypes[i]['id'].toString()
          });
        }
      }
    });
  }

  void hairColorsServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.hairColors}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataHairColors = response['data']['_embedded']['hairColors'];
        for (int i = 0; i < dataHairColors.length; i++) {
          itemHairColors.add({
            'label': dataHairColors[i]['name'],
            'value': dataHairColors[i]['id'].toString()
          });
        }
      }
    });
  }

  void eyeColorsServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.eyeColors}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataEyeColors = response['data']['_embedded']['eyeColors'];
        for (int i = 0; i < dataEyeColors.length; i++) {
          itemEyeColors.add({
            'label': dataEyeColors[i]['name'],
            'value': dataEyeColors[i]['id'].toString()
          });
        }
      }
    });
  }

  void ethnicitiesServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.ethnicities}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataEthnicities = response['data']['_embedded']['ethnicities'];
        for (int i = 0; i < dataEthnicities.length; i++) {
          itemEthnicities.add({
            'label': dataEthnicities[i]['name'],
            'value': dataEthnicities[i]['id'].toString()
          });
        }
      }
    });
  }

  void chinTypesServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.chinTypes}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataChinTypes = response['data']['_embedded']['chinTypes'];
        for (int i = 0; i < dataChinTypes.length; i++) {
          itemChinTypes.add({
            'label': dataChinTypes[i]['name'],
            'value': dataChinTypes[i]['id'].toString()
          });
        }
      }
    });
  }

  void earTypesServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.earTypes}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataEarTypes = response['data']['_embedded']['earTypes'];
        for (int i = 0; i < dataEarTypes.length; i++) {
          itemEarTypes.add({
            'label': dataEarTypes[i]['name'],
            'value': dataEarTypes[i]['id'].toString()
          });
        }
      }
    });
  }

  void skinColorsServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.skinColors}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataSkinColors = response['data']['_embedded']['skinColors'];
        for (int i = 0; i < dataSkinColors.length; i++) {
          itemSkinColors.add({
            'label': dataSkinColors[i]['name'],
            'value': dataSkinColors[i]['id'].toString()
          });
        }
      }
    });
  }

  void bloodTypesServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.bloodTypes}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataBloodTypes = response['data']['_embedded']['bloodTypes'];
        for (int i = 0; i < dataBloodTypes.length; i++) {
          itemBloodTypes.add({
            'label': dataBloodTypes[i]['name'],
            'value': dataBloodTypes[i]['id'].toString()
          });
        }
      }
    });
  }

  void eyeProblemsServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.eyeProblems}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataEyeProblems = response['data']['_embedded']['eyeProblems'];
        for (int i = 0; i < dataEyeProblems.length; i++) {
          itemEyeProblems.add({
            'label': dataEyeProblems[i]['name'],
            'value': dataEyeProblems[i]['id'].toString()
          });
        }
      }
    });
  }

  void teethTypesServices() {
    final url =
        "${FRServer.hostServer}${Endpoint.teethTypes}?page=0&size=999&sort=name,asc";

    Api().serviceGet(url, token: token).then((response) async {
      if (response["statusCode"] == 200) {
        List dataTeethTypes = response['data']['_embedded']['teethTypes'];
        for (int i = 0; i < dataTeethTypes.length; i++) {
          itemTeethTypes.add({
            'label': dataTeethTypes[i]['name'],
            'value': dataTeethTypes[i]['id'].toString()
          });
        }
      }
    });
  }

  void submitCaseServices(paramBody) {
    log("paramBody : $paramBody");
    final url = "${FRServer.hostServer}${Endpoint.createCase}/$casesId/targets";
    setState(() {
      showSpinner = true;
    });

    Api().servicePost(url, paramBody, token: token).then((response) async {
      setState(() {
        showSpinner = false;
      });
      if (response["statusCode"] == 200) {
        //String msg = response['data']['message'];
        Helpers.showAlertModal(
          context,
          AlertGlobal(
            title: isBahasaIndo ? LabelsID.labelSuccess : LabelsEN.labelSuccess,
            isDark: isDark,
            isBahasaIndo: isBahasaIndo,
            labelPress: isBahasaIndo ? LabelsID.label_yes : LabelsEN.label_yes,
            onPress: () {},
            onCatch: () {
              onNavigate("/Stats", {
                "submitCase": "success"
              });
            },
            labelCatch:
                isBahasaIndo ? LabelsID.labelLater : LabelsEN.labelLater,
            desc: isBahasaIndo
                ? LabelsID.labelCaseEvidenceSuccess
                : LabelsEN.labelCaseEvidenceSuccess,
            enableBack: false,
          ),
        );
        //Helpers.viewToast("Success Saved Case", 1);
      } else {
        Helpers.viewToast("Failed Saved Case", 1);
      }
    }).catchError((e) {
      setState(() {
        showSpinner = false;
      });
      Helpers.viewToast(e.toString(), 3);
    });
  }

  void createCaseServices(paramBody) {
    log("paramBody : $paramBody");
    final url = "${FRServer.hostServer}${Endpoint.createCase}";

    Api().servicePost(url, paramBody, token: token).then((response) async {
      log("RESPONSE CreateCases : $response");
      if (response["statusCode"] == 200) {
        String msg = response['data']['message'];
        casesId = response['data']['caseId'];
        print("iddddddd $casesId");
        nextPage();

        Helpers.viewToast("Success Saved Case", 1);
      } else {
        Helpers.viewToast("Failed Saved Case", 1);
      }
    }).catchError((e) {
      Helpers.viewToast(e.toString(), 3);
    });
  }

  void editCaseServices(paramBody) {
    log("paramBody : $paramBody");
    final url = "${FRServer.hostServer}${Endpoint.createCase}${casesId}";

    Api().servicePut(url, paramBody, token: token).then((response) async {
      log("RESPONSE CreateCases : $response");
      if (response["statusCode"] == 200) {
        String msg = response['data']['message'];
        // casesId = response['data']['caseId'];
        // print("iddddddd $casesId");
        nextPage();

        Helpers.viewToast("Success Saved Case", 1);
      } else {
        Helpers.viewToast("Failed Saved Case", 1);
      }
    }).catchError((e) {
      Helpers.viewToast(e.toString(), 3);
    });
  }

  @override
  Widget build(BuildContext context) {
    var spaceBar = Helpers.onSpaceBar(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;
    var heightMenu = screenHeight - (sizeHeadView?.height ?? 0);
    var fontColor = isDark ? white : black;
    var containerBottom = isDark ? black2 : white;
    var heightMenuHead = heightMenu;

    sizeScWidth = screenWidth / 3;

    if (heightMenuHead < 500)
      heightMenuHead = heightMenu / 10;
    else
      heightMenuHead = heightMenu / 20;

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
                  Container(
                      //apply margin and padding using Container Widget.
                      margin: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: goBack,
                            child: Container(
                                //apply margin and padding using Container Widget.
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset("assets/img/back.png"),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  isBahasaIndo
                                      ? LabelsID.label_btn_back
                                      : LabelsEN.label_btn_back,
                                  style: Helpers.font1(14.0,
                                      isDark ? gray : black2, FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            )),
                          ),
                          Text(
                            isBahasaIndo
                                ? LabelsID.labelCreateCase
                                : LabelsEN.labelCreateCase,
                            style: Helpers.font1(
                                14.0, isDark ? gray : black2, FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      )),
                  Container(
                      width: screenWidth,
                      height: heightMenuHead,
                      color: grayCase,
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      alignment: Alignment.center,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: caseLabelList.length,
                        itemBuilder: (context, index) {
                          var dataCaseList = caseLabelList[index];
                          if (selectedTab == index)
                            labelTab = isBahasaIndo
                                ? dataCaseList["titleID"]
                                : dataCaseList["titleEN"];
                          return MenuCaseList(
                              dataCaseList: dataCaseList,
                              isBahasaIndo: isBahasaIndo,
                              isDark: isDark,
                              selectedTab: selectedTab,
                              index: index,
                              actionTab: () {
                                setState(() {
                                  selectedTab = index;
                                  pageTab = index + 1;
                                  labelTab = isBahasaIndo
                                      ? dataCaseList["titleID"]
                                      : dataCaseList["titleEN"];
                                });
                              });
                        },
                      )),
                  Container(
                      //apply margin and padding using Container Widget.
                      margin: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            labelTab,
                            style: Helpers.font1(
                                14.0, isDark ? gray : black2, FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          /* Text(
                        "$pageTab/3",
                        style: Helpers.font1(
                            14.0, isDark ? gray : black2, FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ), */
                        ],
                      )),
                  Container(
                    height: screenHeight / 1.3,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                          bottom: 50.0,
                          left: defaultPadding,
                          right: defaultPadding),
                      child: Column(mainAxisSize: MainAxisSize.max, children: [
                        if (pageTab == 1)
                          pageOne()
                        else if (pageTab == 2)
                          pageTwo()
                        else if (pageTab == 3)
                          pageThree(),
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class MenuCaseList extends StatelessWidget {
  final dynamic dataCaseList;
  final bool isBahasaIndo;
  final bool isDark;
  final int selectedTab;
  final int index;
  final VoidCallback actionTab;
  MenuCaseList(
      {this.dataCaseList,
      required this.isBahasaIndo,
      required this.isDark,
      required this.selectedTab,
      required this.index,
      required this.actionTab});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: actionTab,
      child: Container(
        padding: const EdgeInsets.only(
            left: 10.0, top: 0.0, right: 15.0, bottom: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (selectedTab != index)
                  Image.asset(
                    "assets/img/circle_gray.png",
                    width: defaultSizeIcon,
                    height: defaultSizeIcon,
                  )
                else
                  Image.asset(
                    "assets/img/circle_blue.png",
                    width: defaultSizeIcon,
                    height: defaultSizeIcon,
                  ),
                const SizedBox(
                  width: defaultPadding / 5,
                ),
                Text(
                  isBahasaIndo
                      ? dataCaseList["titleID"]
                      : dataCaseList["titleEN"],
                  style: Helpers.font1(
                      12.0, isDark ? gray : black2, FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
