import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:face_recog_flutter/Pages/Report/pdfApi.dart';
import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageDetail extends StatefulWidget {
  const PageDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<PageDetail> createState() => PageDetailState();
}

class PageDetailState extends State<PageDetail> {
  var keyHeadView = GlobalKey();
  Size? sizeHeadView;
  bool isDark = false;
  bool isBahasaIndo = true;
  String token = "";
  String type = "";
  File? image_;
  bool showSpinner = false;

  List<dynamic> resultDataList = [];
  List<dynamic> resultDataNik = [];
  dynamic selectedData = [];

  List formDetail = [
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "titleID": LabelsID.labelDetailNik,
      "titleEN": LabelsEN.labelDetailNik,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "titleID": LabelsID.labelDetailNama,
      "titleEN": LabelsEN.labelDetailNama,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "titleID": LabelsID.labelDetailTempatLahir,
      "titleEN": LabelsEN.labelDetailTempatLahir,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "titleID": LabelsID.labelDetailTanggalLahir,
      "titleEN": LabelsEN.labelDetailTanggalLahir,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "titleID": LabelsID.labelJenisKelamin,
      "titleEN": LabelsEN.labelDetailJenisKelamin,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "titleID": LabelsID.labelDetailGolDarah,
      "titleEN": LabelsEN.labelDetailGolDarah,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "maxLines": 2,
      "titleID": LabelsID.labelDetailAlamat,
      "titleEN": LabelsEN.labelDetailAlamat,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "titleID": LabelsID.labelDetailRTRW,
      "titleEN": LabelsEN.labelDetailRTRW,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "titleID": LabelsID.labelDetailKelurahan,
      "titleEN": LabelsEN.labelDetailKelurahan,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "titleID": LabelsID.labelDetailKecamatan,
      "titleEN": LabelsEN.labelDetailKecamatan,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "titleID": LabelsID.labelDetailAgama,
      "titleEN": LabelsEN.labelDetailAgama,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "titleID": LabelsID.labelDetailStatusKawin,
      "titleEN": LabelsEN.labelDetailStatusKawin,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "titleID": LabelsID.labelDetailPekerjaan,
      "titleEN": LabelsEN.labelDetailPekerjaan,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "titleID": LabelsID.labelDetailKewarganegaraan,
      "titleEN": LabelsEN.labelDetailKewarganegaraan,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.none,
      "titleID": LabelsID.labelDetailBerlakuHingga,
      "titleEN": LabelsEN.labelDetailBerlakuHingga,
    },
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        var arguments = (ModalRoute.of(context)?.settings.arguments
                as Map<String, dynamic>?) ??
            {};
        setState(() {
          sizeHeadView = Helpers.getBoxSize(keyHeadView.currentContext!);
          type = arguments["tipe"];
          int selectedIndex = arguments["selectedIndex"];
          resultDataList = arguments["response"] ?? [];
          resultDataNik = arguments["response1"] ?? [];
          image_ = arguments["image"];

          log("image_ : $image_");
          log("resultDataList : $resultDataList");
          log("resultDataNik : $resultDataNik");
          
          if (resultDataList.isNotEmpty) {
            selectedData = resultDataList[selectedIndex];
          }

          formDetail[0]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["nik"] ?? "-"
              : resultDataNik[0]["nik"] ?? "-";
          formDetail[1]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["nama"] ?? "-"
              : resultDataNik[0]["nama"] ?? "-";
          formDetail[2]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["tempatLahir"] ?? "-"
              : resultDataNik[0]["tempatLahir"] ?? "-";
          formDetail[3]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["tanggalLahir"] ?? "-"
              : resultDataNik[0]["tanggalLahir"] ?? "-";
          formDetail[4]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["jenisKelamin"] ?? "-"
              : resultDataNik[0]["jenisKelamin"] ?? "-";
          formDetail[5]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["golDarah"] ?? "-"
              : resultDataNik[0]["golDarah"] ?? "-";
          formDetail[6]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["alamat"] ?? "-"
              : resultDataNik[0]["alamat"] ?? "-";
          formDetail[7]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["rtRw"] ?? "-"
              : resultDataNik[0]["rtRw"] ?? "-";
          formDetail[8]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["kelurahan"] ?? "-"
              : resultDataNik[0]["kelurahan"] ?? "-";
          formDetail[9]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["kecamatan"] ?? "-"
              : resultDataNik[0]["kecamatan"] ?? "-";
          formDetail[10]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["agama"] ?? "-"
              : resultDataNik[0]["agama"] ?? "-";
          formDetail[11]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["statusKawin"] ?? "-"
              : resultDataNik[0]["statusKawin"] ?? "-";
          formDetail[12]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["pekerjaan"] ?? "-"
              : resultDataNik[0]["pekerjaan"] ?? "-";
          formDetail[13]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["kewarganegaraan"] ?? "-"
              : resultDataNik[0]["kewarganegaraan"] ?? "-";
          formDetail[14]["inpController"].text = resultDataList.isNotEmpty
              ? selectedData["personDetail"]["berlakuHingga"] ?? "-"
              : resultDataNik[0]["berlakuHingga"] ?? "-";
        });
      }
    });
    setStateManager();
    super.initState();
  }

  // CustomWidget
  Widget detailForm(isDark, isBahasaIndo) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(defaultPadding),
        itemCount: formDetail.length,
        itemBuilder: (context, index) {
          var inputForm = formDetail[index];
          bool? isObscure = inputForm["isObscure"];
          int maxLines_ = inputForm["maxLines"] ?? 1;
          return TextFieldDefault(
            isDark: isDark,
            title: isBahasaIndo ? inputForm["titleID"] : inputForm["titleEN"],
            hintText: '',
            inputType: inputForm["keyboardType"] == null
                ? '-'
                : inputForm["keyboardType"],
            isObscure: isObscure ?? false,
            inputController: inputForm["inpController"],
            enabled: false,
            maxLines: maxLines_,
          );
        });
  }

  //Default Function
  void goBack() {
    Navigator.pop(context);
  }

  void createReport() async {
    final pdfFile = await pdfApi.generateReport(image_,selectedData,resultDataNik,isBahasaIndo);
    pdfApi.downloadFile(pdfFile, "reportFaceIdentify.pdf");
    //pdfApi.openFile(pdfFile);
  }

  void setStateManager() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('IS_DARK') ?? false;
      isBahasaIndo = prefs.getBool('IS_BAHASA') ?? true;
      token = prefs.getString('TOKEN') ?? '';
    });

    await Permission.storage.request();
  }

  void onNavigate(pages, parsingData) {
    Navigator.pushNamed(context, pages, arguments: parsingData);
  }

  @override
  Widget build(BuildContext context) {
    var spaceBar = Helpers.onSpaceBar(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;
    var heightMenu = screenHeight - (sizeHeadView?.height ?? 0);
    return Background(
        isDarkTheme: isDark,
        isShowSpinner: showSpinner,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarLogo(
                keyAppBar: keyHeadView,
                isDark: isDark,
              ),
              SizedBox(
                width: screenWidth,
                height: heightMenu,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                                      style: Helpers.font1(
                                          14.0,
                                          isDark ? gray : black2,
                                          FontWeight.w400),
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
                              style: Helpers.font1(14.0, isDark ? gray : black2,
                                  FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: defaultPadding,
                            top: defaultPadding / 2,
                            right: defaultPadding,
                            bottom: defaultPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isBahasaIndo
                                  ? LabelsID.labelPersonalDetail
                                  : LabelsEN.labelPersonalDetail,
                              style: Helpers.font1(14.0, isDark ? gray : black2,
                                  FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            ButtonPinch(
                                onPressed: createReport,
                                boxColor: transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/img/papers.png",
                                      height: defaultSizeIcon,
                                      width: defaultSizeIcon,
                                      fit: BoxFit.contain,
                                      gaplessPlayback: true,
                                      filterQuality: FilterQuality.medium,
                                    ),
                                    const SizedBox(
                                      width: defaultPadding / 2,
                                    ),
                                    Text(
                                      isBahasaIndo
                                          ? LabelsID.labelCreateReport
                                          : LabelsEN.labelCreateReport,
                                      style: Helpers.font1(
                                          14.0,
                                          isDark ? gray : black2,
                                          FontWeight.w400),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.8,
                        height: screenWidth * 0.8,
                        child: Stack(
                          children: [
                            ClipRRect(
                                borderRadius:
                                    Helpers.onRadius(1, defaultPaddingContain),
                                child: selectedData.isNotEmpty
                                    ? Image.memory(
                                        base64Decode(
                                          selectedData["personDetail"]
                                              ["imageUrl"],
                                        ),
                                        width: screenWidth * 0.8,
                                        height: screenWidth * 0.8,
                                        fit: BoxFit.cover,
                                      )
                                    : resultDataNik.isNotEmpty
                                        ? Image.memory(
                                            base64Decode(
                                              resultDataNik[0]["foto"],
                                            ),
                                            width: screenWidth * 0.8,
                                            height: screenWidth * 0.8,
                                            fit: BoxFit.cover,
                                          )
                                        : Text("no image")),
                            Positioned(
                              bottom: 0,
                              child: ButtonPinch(
                                boxColor: transparent,
                                onPressed: () => onNavigate("/CreateCase", {
                                  "tipe": "CreateCase",
                                  "response": resultDataList,
                                  "response1": resultDataNik,
                                }),
                                child: Container(
                                  width: screenWidth * 0.8,
                                  height: (screenWidth * 0.8) * 0.15,
                                  decoration: BoxDecoration(
                                      color: basic,
                                      borderRadius: Helpers.onRadius(
                                          2, defaultPaddingContain)),
                                  padding: const EdgeInsets.all(
                                      defaultPaddingContain),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        isDark
                                            ? 'assets/img/Vector.png'
                                            : 'assets/img/Vector.png',
                                        width: (defaultPadding * 2) / 2,
                                        height: (defaultPadding * 2) / 2,
                                        fit: BoxFit.contain,
                                        gaplessPlayback: true,
                                        filterQuality: FilterQuality.medium,
                                      ),
                                      const SizedBox(width: defaultPadding / 3),
                                      Text(
                                        isBahasaIndo
                                            ? LabelsID.labelCreateCase
                                            : LabelsEN.labelCreateCase,
                                        style: Helpers.font1(
                                            15.0,
                                            isDark ? black2 : gray,
                                            FontWeight.w400),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      detailForm(isDark, isBahasaIndo),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
