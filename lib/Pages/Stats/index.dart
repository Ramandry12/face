import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_pagination/flutter_pagination.dart';
import 'package:flutter_pagination/widgets/button_styles.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatsScreen> createState() => StatsScreenState();
}

class StatsScreenState extends State<StatsScreen> {
  var keyHeadView = GlobalKey();
  var keyBottomView = GlobalKey();
  final controllerSearch = TextEditingController();
  Size? sizeHeadView;
  Size? sizeBottomView;
  bool isDark = false;
  bool isBahasaIndo = true;
  String token = '';
  int currentPage = 0;
  int pageSize = 5;
  int totalElements = 0;
  int totalPage = 0;
  int numberPage = 0;
  List<Map<String, dynamic>> pages = [];
  List<dynamic> itemCases = [];
  List<dynamic> itemCasesFiltered = [];
  List<dynamic> listItemRecentSearch = [];
  List<dynamic> listItemRecentSearchFiltered = [];
  List<dynamic> listItemRecentCases = [];
  String submitCase = "";

  List<dynamic> itemCaseStatus = [
    {
      "label": "CASE STATUS 1",
      "value": "case_status1",
    },
    {
      "label": "CASE STATUS 2",
      "value": "case_status2",
    }
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        var arguments = null;
        if (ModalRoute.of(context)?.settings.arguments != "") {
          arguments = (ModalRoute.of(context)?.settings.arguments ??
              <String, dynamic>{}) as Map;
        }
        setState(() {
          sizeHeadView = Helpers.getBoxSize(keyHeadView.currentContext!);
          sizeBottomView = Helpers.getBoxSize(keyBottomView.currentContext!);
          if (arguments != null) {
            submitCase = arguments["submitCase"];
          }
        });
        setStateManager();
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

  void dialogSubmitCase() async {
    Helpers.showAlertModal(
      context,
      AlertGlobal(
        title: isBahasaIndo ? LabelsID.labelSuccess : LabelsEN.labelSuccess,
        isDark: isDark,
        isBahasaIndo: isBahasaIndo,
        desc: isBahasaIndo
            ? LabelsID.labelCaseSuccess
            : LabelsEN.labelCaseSuccess,
        enableBack: false,
      ),
    );
  }

  void setStateManager() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('IS_DARK') ?? false;
      isBahasaIndo = prefs.getBool('IS_BAHASA') ?? true;
      listItemRecentSearch =
          jsonDecode(prefs.getString('RECENT_SEARCH') ?? '[]');
      listItemRecentSearchFiltered =
          jsonDecode(prefs.getString('RECENT_SEARCH') ?? '[]');
      token = prefs.getString('TOKEN') ?? '';
      apiGetCases();

      log("itemmmm $itemCases");
    });

    if (submitCase == "success") {
      dialogSubmitCase();
    }
  }

  void apiGetCases() async {
    final url =
        "${FRServer.hostServer}${Endpoint.createCase}?page=${currentPage}&size=$pageSize";
    print("tokennih $token");

    Api().serviceGet(url, token: token).then((response) async {
      log("dataaaa ${response["data"]}");
      if (response["statusCode"] == 200) {
        List dataCaseSubTypes = response['data']["data"];
        for (int i = 0; i < dataCaseSubTypes.length; i++) {
          setState(() {
            String date = dataCaseSubTypes[i]["dateCase"].toString();
            DateTime dateTime = DateTime.parse(date);
            String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
            log(formattedDate);

            itemCases.add({
              'value': dataCaseSubTypes[i]["caseType"]["name"],
              'operator': dataCaseSubTypes[i]["operator"],
              'description': dataCaseSubTypes[i]["description"],
              'status': dataCaseSubTypes[i]["caseStatus"]["name"],
              'date': formattedDate,
              'id': dataCaseSubTypes[i]["id"],
            });
            itemCasesFiltered
                .add({'value': dataCaseSubTypes[i]["caseType"]["name"]});
          });
        }
        setState(() {
          totalElements = response['data']["page"]["totalElements"];
          totalPage = response['data']["page"]["totalPages"];
        });
      } else {
        log("gagal");
      }
    }).catchError((e) {
      Helpers.viewToast(e.toString(), 3);
    });
    ;
  }

  //CustomWidget
  Widget listRecentSearch(width_, height_) {
    var fontColor = isDark ? white : black;
    var spaceBar = Helpers.onSpaceBar(context);
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;
    print(itemCases.isEmpty ? "itemCases is empty." : "adaaa");
    log("itemmmm $itemCases");

    if (itemCases.isEmpty) {
      return Container(
        width: width_,
        height: screenHeight / 2.5,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? white : gray,
              width: 0.7,
            ),
            left: BorderSide(
              color: isDark ? white : gray,
              width: 0.7,
            ),
            right: BorderSide(
              color: isDark ? white : gray,
              width: 0.7,
            ),
          ),
          color: isDark ? black : white,
        ),
        child: Text(
          isBahasaIndo ? LabelsID.labelDataKosong : LabelsEN.labelDataKosong,
          style: Helpers.font1(14.0, fontColor, FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.start,
        ),
      );
    } else {
      // print("masukkkkkkkkk");
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: itemCases.length,
          itemBuilder: (context, index) {
            var itemRecent_ = itemCases[index];
            // print("itemmmmmm $itemRecent_");
            var indexTerakhir = itemCases.length - 1;
            return ButtonPinch(
              onPressed: () {
                // onNavigate('/CreateCase', {
                //   "tipe": "CreateCase",
                //   "response": listItemRecentSearchFiltered,
                //   "selectedIndex": index
                // });
              },
              scale: 0.95,
              boxColor: transparent,
              isShadow: false,
              radius: 0,
              isBorder: false,
              enable: true,
              paddingChild: const EdgeInsets.all(0.0),
              child: Slidable(
                key: Key("$itemRecent_"),
                startActionPane:
                    ActionPane(motion: const ScrollMotion(), children: [
                  SlidableAction(
                    onPressed: (context) {},
                    backgroundColor: basic,
                    icon: Icons.edit_document,
                  ),
                ]),
                endActionPane:
                    ActionPane(motion: const ScrollMotion(), children: [
                  SlidableAction(
                    onPressed: (context) {},
                    backgroundColor: Red,
                    icon: Icons.delete,
                  ),
                ]),
                child: Container(
                  width: width_,
                  height: height_,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? white : gray,
                        width: 0.7,
                      ),
                      left: BorderSide(
                        color: isDark ? white : gray,
                        width: 0.7,
                      ),
                      right: BorderSide(
                        color: isDark ? white : gray,
                        width: 0.7,
                      ),
                    ),
                    color: isDark ? black : white,
                  ),
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius:
                            Helpers.onRadius(1, defaultPaddingContain),
                        child: Text(
                          '${index + 1}',
                          style:
                              Helpers.font1(12.0, fontColor, FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemRecent_["value"].toUpperCase(),
                              style: Helpers.font1(
                                  10.0, fontColor, FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                            ),
                            // Text(
                            //   itemRecent_["description"] == null
                            //       ? 'Tidak Ada - ' + itemRecent_["operator"]
                            //       : ' ${itemRecent_["description"]} - ' +
                            //           itemRecent_["operator"],
                            //   style: Helpers.font2(
                            //       14.0, fontColor, FontWeight.w400),
                            //   overflow: TextOverflow.ellipsis,
                            //   maxLines: 1,
                            //   textAlign: TextAlign.start,
                            // ),
                            Text(
                              itemRecent_["date"] +
                                  " - " +
                                  itemRecent_["status"],
                              style: Helpers.font2(
                                  14.0, fontColor, FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Background(
          isDarkTheme: isDark,
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
                        width: screenWidth,
                        height: heightMenu,
                        padding: const EdgeInsets.all(0.0),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/img/case.png",
                                    width: defaultSizeIcon,
                                    height: defaultSizeIcon,
                                  ),
                                  const SizedBox(
                                    width: defaultPadding / 2,
                                  ),
                                  Text(
                                    isBahasaIndo
                                        ? LabelsID.labelStatistikTitle
                                        : LabelsEN.labelStatistikTitle,
                                    style: Helpers.font1(
                                        18.0,
                                        isDark ? gray : black2,
                                        FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              Text(
                                isBahasaIndo
                                    ? LabelsID.labelStatistikList
                                    : LabelsEN.labelStatistikList,
                                style: Helpers.font2(15.0,
                                    isDark ? gray : black2, FontWeight.w400),
                              ),
                              const SizedBox(
                                height: defaultPadding / 2,
                              ),
                              MainButtonIcon(
                                onPressed: () => onNavigate('/CreateCase', {
                                  "tipe": "CreateCase",
                                }),
                                iconButton: Icons.add_circle_outline,
                                width:
                                    ((screenWidth - defaultPadding * 2) / 2) -
                                        (defaultPadding / 2),
                                label: isBahasaIndo
                                    ? LabelsID.labelStatistikButton
                                    : LabelsEN.labelStatistikButton,
                                fontStyle:
                                    Helpers.font1(14.0, white, FontWeight.w400),
                              ),
                              const SizedBox(height: defaultPadding / 2),
                              TextFieldDefault(
                                isDark: isDark,
                                hintText: isBahasaIndo
                                    ? LabelsID.hintStatistikSearch
                                    : LabelsEN.hintStatistikSearch,
                                inputType: TextInputType.text,
                                suffixIcon: Icon(
                                  Icons.search,
                                  size: 24,
                                  color: isDark
                                      ? gray.withOpacity(0.5)
                                      : black2.withOpacity(0.5),
                                ),
                                inputController: controllerSearch,
                                onChanged: (value) {
                                  log("value = $value");
                                  if (value.isEmpty) {
                                    setState(() {
                                      itemCases = itemCasesFiltered;
                                    });
                                  } else {
                                    setState(() {
                                      itemCases = itemCasesFiltered
                                          .where((item) => item["value"]
                                              .toLowerCase()
                                              .contains(value.toLowerCase()))
                                          .toList();
                                    });
                                  }
                                },
                              ),
                              const SizedBox(
                                height: defaultPadding / 2,
                              ),
                              Container(
                                width: screenWidth - defaultPadding * 2,
                                padding:
                                    const EdgeInsets.all(defaultPadding * 0.6),
                                decoration: BoxDecoration(
                                    color: isDark ? black2 : blackMed,
                                    borderRadius: Helpers.onRadius(
                                        3, defaultPaddingContain),
                                    border: Border(
                                      bottom: BorderSide(
                                          color: isDark ? white : gray,
                                          width: 1.0),
                                      top: BorderSide(
                                          color: isDark ? white : gray,
                                          width: 1.0),
                                      left: BorderSide(
                                          color: isDark ? white : gray,
                                          width: 1.0),
                                      right: BorderSide(
                                          color: isDark ? white : gray,
                                          width: 1.0),
                                    )),
                                child: Text(
                                  isBahasaIndo
                                      ? LabelsID.labelStatistikList
                                      : LabelsEN.labelStatistikList,
                                  style: Helpers.font1(15.0,
                                      isDark ? gray : black2, FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              listRecentSearch(screenWidth - defaultPadding * 2,
                                  (screenWidth - defaultPadding * 2) / 3.5),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              // Pagination(
                              //   width:
                              //       screenWidth * .6, // this prop is optional
                              //   paginateButtonStyles: PaginateButtonStyles(
                              //     backgroundColor: isDark ? basic : basic,
                              //   ),
                              //   prevButtonStyles: PaginateSkipButton(
                              //       buttonBackgroundColor: basic,
                              //       borderRadius: const BorderRadius.only(
                              //           topLeft: Radius.circular(20),
                              //           bottomLeft: Radius.circular(20))),
                              //   nextButtonStyles: PaginateSkipButton(
                              //       buttonBackgroundColor: basic,
                              //       borderRadius: const BorderRadius.only(
                              //           topRight: Radius.circular(20),
                              //           bottomRight: Radius.circular(20))),
                              //   onPageChange: (number) {
                              //     setState(() {
                              //       apiGetCases();
                              //       currentPage = number;
                              //       log(" pagesssss $pageSize");
                              //     });
                              //   },
                              //   useGroup: true,
                              //   totalPage: 10,
                              //   show: 4,
                              //   currentPage: currentPage,
                              // ),
                              SizedBox(
                                height: (sizeBottomView?.height ?? 0),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              BottomNavigationMenu(
                keyBottomNavigation: keyBottomView,
                isDark: isDark,
                activeItem: "stats",
                isBahasaIndo: isBahasaIndo,
                width: screenWidth,
                height: (screenWidth * 0.15) + defaultPadding * 2,
              )
            ],
          )),
    );
  }
}
