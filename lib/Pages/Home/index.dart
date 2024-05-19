import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  var keyHeadView = GlobalKey();
  var keyBottomView = GlobalKey();
  Size? sizeHeadView;
  Size? sizeBottomView;
  bool isDark = false;
  bool isBahasaIndo = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          sizeHeadView = Helpers.getBoxSize(keyHeadView.currentContext!);
          sizeBottomView = Helpers.getBoxSize(keyBottomView.currentContext!);
        });
      }
    });
    super.initState();
    setStateManager();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    var spaceBar = Helpers.onSpaceBar(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;
    var heightMenu = screenHeight - (sizeHeadView?.height ?? 0);
    var fontColor = isDark ? white : black;
    var ctime;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          DateTime now = DateTime.now();
          if (ctime == null || now.difference(ctime) > Duration(seconds: 2)) {
            //add duration of press gap
            ctime = now;
            Helpers.viewToast(
                isBahasaIndo
                    ? LabelsID.labelBackToExit
                    : LabelsEN.labelBackToExit,
                3);
            return Future.value(false);
          }
          SystemNavigator.pop();
          return Future.value(true);
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
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                Container(
                                  width: screenWidth - defaultPadding * 2,
                                  padding: const EdgeInsets.all(
                                      defaultPaddingContain),
                                  decoration: BoxDecoration(
                                    borderRadius: Helpers.onRadius(
                                        1, defaultPaddingContain),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: isDark ? white : gray,
                                        width: 0.7,
                                      ),
                                      top: BorderSide(
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
                                  child: SfCartesianChart(
                                    title: ChartTitle(
                                        text: 'Number of Cases in one year',
                                        textStyle: Helpers.font1(
                                            13.0, black2, FontWeight.w600)),
                                    primaryXAxis: CategoryAxis(),
                                    primaryYAxis: NumericAxis(),
                                    series: <ChartSeries>[
                                      BarSeries<SalesData, String>(
                                          dataSource: <SalesData>[
                                            SalesData('Banten', 10),
                                            SalesData('Jawa Timur', 44),
                                            SalesData('Bali', 54),
                                            SalesData('Kalimantan Barat', 68),
                                            SalesData('Maluku Utara', 70),
                                          ],
                                          xValueMapper: (SalesData sales, _) =>
                                              sales.month,
                                          yValueMapper: (SalesData sales, _) =>
                                              sales.sales,
                                          color: basicE,
                                          borderRadius: Helpers.onRadius(
                                              1, defaultPaddingContain / 2)),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: defaultPadding,
                                ),
                                Container(
                                  width: screenWidth - defaultPadding * 2,
                                  padding: const EdgeInsets.all(
                                      defaultPaddingContain),
                                  decoration: BoxDecoration(
                                    borderRadius: Helpers.onRadius(
                                        1, defaultPaddingContain),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: isDark ? white : gray,
                                        width: 0.7,
                                      ),
                                      top: BorderSide(
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
                                  child: SfCartesianChart(
                                    title: ChartTitle(
                                        text: 'Top 5 Most Case Locations',
                                        textStyle: Helpers.font1(
                                            13.0, black2, FontWeight.w600)),
                                    primaryXAxis: CategoryAxis(),
                                    primaryYAxis: NumericAxis(),
                                    series: <ChartSeries>[
                                      BarSeries<SalesData, String>(
                                          dataSource: <SalesData>[
                                            SalesData('Banten', 10),
                                            SalesData('Jawa Timur', 44),
                                            SalesData('Bali', 54),
                                            SalesData('Kalimantan Barat', 68),
                                            SalesData('Maluku Utara', 70),
                                          ],
                                          xValueMapper: (SalesData sales, _) =>
                                              sales.month,
                                          yValueMapper: (SalesData sales, _) =>
                                              sales.sales,
                                          borderRadius: Helpers.onRadius(
                                              1, defaultPaddingContain / 2)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: (sizeBottomView?.height ?? 0),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
                BottomNavigationMenu(
                  keyBottomNavigation: keyBottomView,
                  isDark: isDark,
                  activeItem: "home",
                  isBahasaIndo: isBahasaIndo,
                  width: screenWidth,
                  height: (screenWidth * 0.15) + defaultPadding * 2,
                )
              ],
            )),
      ),
    );
  }
}

class SalesData {
  SalesData(this.month, this.sales);
  final String month;
  final double sales;
}
