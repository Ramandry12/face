import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindResultScreen extends StatefulWidget {
  const FindResultScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FindResultScreen> createState() => FindResultScreenState();
}

class FindResultScreenState extends State<FindResultScreen> {
  var keyHeadView = GlobalKey();
  Size? sizeHeadView;
  bool isDark = false;
  bool isBahasaIndo = true;
  bool isSpinner = false;
  String type = "";
  File? image_;
  String searchNik = "";
  String token = "";
  List<dynamic> resultDataList = [];
  List<dynamic> resultDataNik = [];
  String formatAsPercentage(double value) {
    String percentage = (value * 100).toStringAsFixed(2);
    return '$percentage%';
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        var arguments = (ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{}) as Map;
        log(arguments.toString());
        print("resulttt $resultDataList");

        setState(() {
          sizeHeadView = Helpers.getBoxSize(keyHeadView.currentContext!);
          type = arguments["tipe"];
          image_ = arguments["image"];
          searchNik = arguments["searchNik"];
          token = arguments["token"];
        });
        setStateManager();
        if (image_ != null && searchNik == "") {
          apiSearchImage(image_!);
        } else if (image_ == null && searchNik != "") {
          apiSearchNik(searchNik);
        }
      }
    });
    super.initState();
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
    });
  }

  //CustomWidget
  Widget listRecentSearch(width_, height_) {
    var fontColor = isDark ? white : black;
    var spaceBar = Helpers.onSpaceBar(context);
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;

    if (!isSpinner && resultDataList.isNotEmpty) {
      return Container(
        height: screenHeight / 1.7,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(
                left: 0.0, top: 0.0, right: 0.0, bottom: 50.0),
            itemCount: resultDataList.length,
            itemBuilder: (context, index) {
              var indexTerakhir = resultDataList.length - 1;
              return ButtonPinch(
                onPressed: () {
                  onNavigate('/PageDetail', {
                    "tipe": "PageDetail",
                    "response": resultDataList,
                    "response1": resultDataNik,
                    "image": image_,
                    "selectedIndex": index
                  });
                },
                scale: 0.95,
                boxColor: transparent,
                isShadow: false,
                radius: 0,
                isBorder: false,
                enable: true,
                paddingChild: const EdgeInsets.all(0.0),
                child: Container(
                  width: width_,
                  height: height_,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: index == indexTerakhir
                            ? isDark
                                ? black
                                : white
                            : isDark
                                ? white
                                : gray,
                        width: index == indexTerakhir ? 0.0 : 0.7,
                      ),
                    ),
                    color: isDark ? black : white,
                  ),
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius:
                            Helpers.onRadius(1, defaultPaddingContain),
                        child: Image.memory(
                          base64Decode(
                            resultDataList.isNotEmpty
                                ? resultDataList[index]["personDetail"]
                                    ["imageUrl"]
                                : '',
                          ),
                          height: height_ - defaultPadding * 2,
                          width: height_ - defaultPadding * 2,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                      const SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            resultDataList.isNotEmpty
                                ? ' (${formatAsPercentage(resultDataList[index]["similarity"])})'
                                : '-',
                            style:
                                Helpers.font1(14.0, fontColor, FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            resultDataList.isNotEmpty
                                ? resultDataList[index]["personDetail"]["nama"]
                                : '-',
                            style:
                                Helpers.font1(13.0, fontColor, FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            resultDataList.isNotEmpty
                                ? resultDataList[index]["personDetail"]["nik"]
                                : '-',
                            style:
                                Helpers.font2(12.0, fontColor, FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      );
    } else if (isSpinner) {
      return Container(
        height: screenHeight / 1.7,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0.0),
            itemCount: 3,
            itemBuilder: (context, index) {
              var indexTerakhir = resultDataList.length - 1;
              return Container(
                width: width_,
                height: height_,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: index == indexTerakhir
                          ? isDark
                              ? black
                              : white
                          : isDark
                              ? white
                              : gray,
                      width: index == indexTerakhir ? 0.0 : 0.7,
                    ),
                  ),
                  color: isDark ? black : white,
                ),
                padding: const EdgeInsets.all(defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShimmerCard(
                      height: height_ - defaultPadding * 2,
                      width: height_ - defaultPadding * 2,
                      borderRadius: Helpers.onRadius(1, defaultPaddingContain),
                    ),
                    const SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerCard(
                          width: (width_ - (width_ / 2.7)) * 0.3,
                          height: defaultPadding * 0.8,
                          borderRadius:
                              Helpers.onRadius(1, defaultPaddingContain / 2),
                        ),
                        const SizedBox(
                          height: defaultPaddingContain / 2,
                        ),
                        ShimmerCard(
                          width: (width_ - (width_ / 2.7)) * 0.5,
                          height: defaultPadding * 0.8,
                          borderRadius:
                              Helpers.onRadius(1, defaultPaddingContain / 2),
                        ),
                        const SizedBox(
                          height: defaultPaddingContain / 2,
                        ),
                        ShimmerCard(
                          width: (width_ - (width_ / 2.7)) * 0.5,
                          height: defaultPadding * 0.8,
                          borderRadius:
                              Helpers.onRadius(1, defaultPaddingContain / 2),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
      );
    } else {
      return Container(
        width: width_,
        height: screenHeight / 1.75,
        alignment: Alignment.center,
        child: Text(
          isBahasaIndo ? LabelsID.labelDataKosong : LabelsEN.labelDataKosong,
          style: Helpers.font1(14.0, fontColor, FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.start,
        ),
      );
    }
  }

  Widget listRecentSearchNik(width_, height_) {
    var fontColor = isDark ? white : black;
    var spaceBar = Helpers.onSpaceBar(context);
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;

    if (!isSpinner && resultDataNik.isNotEmpty) {
      // log("masukkkk");
      return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
          itemCount: resultDataNik.length,
          itemBuilder: (context, index) {
            var indexTerakhir = resultDataNik.length - 1;
            return ButtonPinch(
              onPressed: () {
                onNavigate('/PageDetail', {
                  "tipe": "PageDetail",
                  "response": null,
                  "response1": resultDataNik,
                  "selectedIndex": index
                });
              },
              scale: 0.95,
              boxColor: transparent,
              isShadow: false,
              radius: 0,
              isBorder: false,
              enable: true,
              paddingChild: const EdgeInsets.all(0.0),
              child: Container(
                width: width_,
                height: height_,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: index == indexTerakhir
                          ? isDark
                              ? black
                              : white
                          : isDark
                              ? white
                              : gray,
                      width: index == indexTerakhir ? 0.0 : 0.7,
                    ),
                  ),
                  color: isDark ? black : white,
                ),
                padding: const EdgeInsets.all(defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: Helpers.onRadius(1, defaultPaddingContain),
                      child: Image.memory(
                        base64Decode(
                          resultDataNik.isNotEmpty
                              ? resultDataNik[index]["foto"]
                              : '',
                        ),
                        height: height_ - defaultPadding * 2,
                        width: height_ - defaultPadding * 2,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                    const SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   resultDataNik.isNotEmpty ? '(100%)' : '-',
                        //   style:
                        //       Helpers.font1(14.0, fontColor, FontWeight.w400),
                        //   overflow: TextOverflow.ellipsis,
                        //   maxLines: 1,
                        //   textAlign: TextAlign.start,
                        // ),
                        Text(
                          resultDataNik.isNotEmpty
                              ? resultDataNik[index]["nama"]
                              : '-',
                          style:
                              Helpers.font1(13.0, fontColor, FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          resultDataNik.isNotEmpty
                              ? resultDataNik[index]["nik"]
                              : '-',
                          style:
                              Helpers.font2(12.0, fontColor, FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
    } else if (isSpinner) {
      return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
          itemCount: 3,
          itemBuilder: (context, index) {
            var indexTerakhir = resultDataList.length - 1;
            return Container(
              width: width_,
              height: height_,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: index == indexTerakhir
                        ? isDark
                            ? black
                            : white
                        : isDark
                            ? white
                            : gray,
                    width: index == indexTerakhir ? 0.0 : 0.7,
                  ),
                ),
                color: isDark ? black : white,
              ),
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShimmerCard(
                    height: height_ - defaultPadding * 2,
                    width: height_ - defaultPadding * 2,
                    borderRadius: Helpers.onRadius(1, defaultPaddingContain),
                  ),
                  const SizedBox(
                    width: defaultPadding / 2,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerCard(
                        width: (width_ - (width_ / 2.7)) * 0.3,
                        height: defaultPadding * 0.8,
                        borderRadius:
                            Helpers.onRadius(1, defaultPaddingContain / 2),
                      ),
                      const SizedBox(
                        height: defaultPaddingContain / 2,
                      ),
                      ShimmerCard(
                        width: (width_ - (width_ / 2.7)) * 0.5,
                        height: defaultPadding * 0.8,
                        borderRadius:
                            Helpers.onRadius(1, defaultPaddingContain / 2),
                      ),
                      const SizedBox(
                        height: defaultPaddingContain / 2,
                      ),
                      ShimmerCard(
                        width: (width_ - (width_ / 2.7)) * 0.5,
                        height: defaultPadding * 0.8,
                        borderRadius:
                            Helpers.onRadius(1, defaultPaddingContain / 2),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
    } else {
      return Container(
        width: width_,
        height: screenHeight / 1.75,
        alignment: Alignment.center,
        child: Text(
          isBahasaIndo ? LabelsID.labelDataKosong : LabelsEN.labelDataKosong,
          style: Helpers.font1(14.0, fontColor, FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.start,
        ),
      );
    }
  }

  Widget cardTopNik(width_) {
    if (!isSpinner && resultDataNik.isNotEmpty) {
      return Container(
        width: width_,
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: Helpers.onRadius(1, defaultPaddingContain),
              child: Image.memory(
                base64Decode(
                  resultDataNik.isNotEmpty ? resultDataNik[0]["foto"] : '',
                ),
                width: width_ / 2.7,
                height: width_ / 2.7,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                filterQuality: FilterQuality.medium,
              ),
              // Image.file(
              //   image_!,
              //   width: width_ / 2.7,
              //   height: width_ / 2.7,
              //   fit: BoxFit.cover,
              //   gaplessPlayback: true,
              //   filterQuality: FilterQuality.medium,
              // ),
            ),
            const SizedBox(
              width: defaultPadding,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBahasaIndo
                      ? LabelsID.labelSimilarityRank
                      : LabelsEN.labelSimilarityRank,
                  style: Helpers.font1(
                      14.0, isDark ? gray : black2, FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                Text(
                  isBahasaIndo
                      ? LabelsID.labelDataSource
                      : LabelsEN.labelDataSource,
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w400),
                ),
                Text(
                  "Data source 1",
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w600),
                ),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                Text(
                  "ID",
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w400),
                ),
                Text(
                  resultDataNik[0]["nik"] ?? '',
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w600),
                ),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                Text(
                  isBahasaIndo
                      ? LabelsID.labelJenisKelamin
                      : LabelsEN.labelJenisKelamin,
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w400),
                ),
                Text(
                  resultDataNik[0]["jenisKelamin"] ?? "",
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w600),
                ),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                Text(
                  isBahasaIndo
                      ? LabelsID.labelDataRank
                      : LabelsEN.labelDataRank,
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w400),
                ),
                Text(
                  resultDataNik.length.toString(),
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w600),
                ),
              ],
            )
          ],
        ),
      );
    } else if (isSpinner) {
      return Container(
        width: width_,
        height: width_ * 0.5,
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShimmerCard(
              width: width_ / 2.7,
              height: width_ / 2.7,
              borderRadius: Helpers.onRadius(1, defaultPaddingContain),
            ),
            const SizedBox(
              width: defaultPadding / 2,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerCard(
                  width: (width_ - (width_ / 2.7)) * 0.7,
                  height: defaultPadding * 1.2,
                  borderRadius: Helpers.onRadius(1, defaultPaddingContain / 2),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                ShimmerCard(
                  width: (width_ - (width_ / 2.7)) * 0.6,
                  height: defaultPadding * 1.2,
                  borderRadius: Helpers.onRadius(1, defaultPaddingContain / 2),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                ShimmerCard(
                  width: (width_ - (width_ / 2.7)) * 0.6,
                  height: defaultPadding * 1.2,
                  borderRadius: Helpers.onRadius(1, defaultPaddingContain / 2),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget cardTop(width_) {
    if (!isSpinner && resultDataList.isNotEmpty) {
      return Container(
        width: width_,
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: Helpers.onRadius(1, defaultPaddingContain),
              child: Image.file(
                image_!,
                width: width_ / 2.7,
                height: width_ / 2.7,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                filterQuality: FilterQuality.medium,
              ),
            ),
            const SizedBox(
              width: defaultPadding,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBahasaIndo
                      ? LabelsID.labelSimilarityRank
                      : LabelsEN.labelSimilarityRank,
                  style: Helpers.font1(
                      14.0, isDark ? gray : black2, FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                Text(
                  isBahasaIndo
                      ? LabelsID.labelDataSource
                      : LabelsEN.labelDataSource,
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w400),
                ),
                Text(
                  "Data source 1",
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w600),
                ),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                Text(
                  "ID",
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w400),
                ),
                Text(
                  resultDataList[0]["personDetail"]["nik"] ?? '',
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w600),
                ),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                Text(
                  isBahasaIndo
                      ? LabelsID.labelJenisKelamin
                      : LabelsEN.labelJenisKelamin,
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w400),
                ),
                Text(
                  resultDataList[0]["personDetail"]["jenisKelamin"] ?? "",
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w600),
                ),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                Text(
                  isBahasaIndo
                      ? LabelsID.labelDataRank
                      : LabelsEN.labelDataRank,
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w400),
                ),
                Text(
                  resultDataList.length.toString(),
                  style: Helpers.font2(
                      14.0, isDark ? gray : black2, FontWeight.w600),
                ),
              ],
            )
          ],
        ),
      );
    } else if (isSpinner) {
      return Container(
        width: width_,
        height: width_ * 0.5,
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShimmerCard(
              width: width_ / 2.7,
              height: width_ / 2.7,
              borderRadius: Helpers.onRadius(1, defaultPaddingContain),
            ),
            const SizedBox(
              width: defaultPadding / 2,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerCard(
                  width: (width_ - (width_ / 2.7)) * 0.7,
                  height: defaultPadding * 1.2,
                  borderRadius: Helpers.onRadius(1, defaultPaddingContain / 2),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                ShimmerCard(
                  width: (width_ - (width_ / 2.7)) * 0.6,
                  height: defaultPadding * 1.2,
                  borderRadius: Helpers.onRadius(1, defaultPaddingContain / 2),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                ShimmerCard(
                  width: (width_ - (width_ / 2.7)) * 0.6,
                  height: defaultPadding * 1.2,
                  borderRadius: Helpers.onRadius(1, defaultPaddingContain / 2),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  //Servis
  void apiSearchImage(File? file) async {
    setState(() {
      isSpinner = true;
    });
    print("tokenn $token");
    final url = FRServer.hostServer + Endpoint.searchImage;
    FormData body = FormData.fromMap({
      'file': await MultipartFile.fromFile(file!.path),
      'fetch_limit': 8,
    });
    Api().servicePostImage(url, body, token: token).then((response) async {
      if (response['data']['status'] < 300) {
        if (searchNik != '') {
          apiSearchNik(searchNik);
        } else {
          setState(() {
            isSpinner = false;
          });
        }
        StateManager stateManager = StateManager();
        stateManager.setRecentSearch(response['data']['value']);
        setState(() {
          resultDataList = response['data']['value'];
        });
      } else {
        // Helpers.viewToast(response['data']['message'].toString(), 3);
        setState(() {
          isSpinner = false;
        });
      }
    }).catchError((e) {
      setState(() {
        isSpinner = false;
      });
      Helpers.viewToast(e.toString(), 3);
    });
  }

//Servis NIk
  void apiSearchNik(String searchNik) async {
    setState(() {
      isSpinner = true;
    });
    final url = FRServer.hostServer + Endpoint.searchNik + searchNik;
    print(" tokennn $token");

    Api().serviceGet(url, token: token).then((response) async {
      // print(response['statusCode']);
      print(response['data']['_embedded']['facePersons']);
      if (response['statusCode'] < 300) {
        StateManager stateManager = StateManager();
        stateManager
            .setRecentSearch(response['data']['_embedded']['facePersons']);
        setState(() {
          resultDataNik = response['data']['_embedded']['facePersons'];
        });
      } else {
        // Helpers.viewToast(response['data']['message'].toString(), 3);
        setState(() {
          isSpinner = false;
        });
      }
      setState(() {
        isSpinner = false;
      });
    }).catchError((e) {
      setState(() {
        isSpinner = false;
      });
      Helpers.viewToast(e.toString(), 3);
    });
  }

  @override
  Widget build(BuildContext context) {
    var spaceBar = Helpers.onSpaceBar(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;
    var heightMenu = screenHeight - (sizeHeadView?.height ?? 0);
    return Background(
        isDarkTheme: isDark,
        isShowSpinner: false,
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
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: defaultPadding,
                            right: defaultPadding,
                            top: defaultPadding),
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
                                          15.0,
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
                      resultDataNik.isNotEmpty
                          ? cardTopNik(screenWidth - defaultPadding * 2)
                          : cardTop(screenWidth - defaultPadding * 2),
                      const SizedBox(
                        height: defaultPaddingContain / 2,
                      ),
                      resultDataNik.isNotEmpty
                          ? listRecentSearchNik(
                              screenWidth - defaultPadding * 2,
                              (screenWidth - defaultPadding * 2) / 3.5,
                            )
                          : listRecentSearch(screenWidth - defaultPadding * 2,
                              (screenWidth - defaultPadding * 2) / 3.5),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
