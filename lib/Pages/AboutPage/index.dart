import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AboutPage> createState() => AboutPageState();
}
class AboutPageState extends State<AboutPage> {
  var keyHeadView = GlobalKey();
  Size? sizeHeadView;
  bool isDark = false;
  bool isBahasaIndo = true;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          sizeHeadView = Helpers.getBoxSize(keyHeadView.currentContext!);
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
    });
  }


  @override
  Widget build(BuildContext context) {
    var spaceBar = Helpers.onSpaceBar(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;
    return Background(
        isDarkTheme: isDark,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarText(
                  keyAppBar: keyHeadView,
                  onPressed: goBack,
                  isDark: isDark,
                  label: isBahasaIndo ? LabelsID.labelTentang.toUpperCase() : LabelsEN.labelTentang.toUpperCase()
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(defaultPadding),
                child: Container(
                  width: screenWidth,
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    borderRadius: Helpers.onRadius(1, 8),
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
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                    style: Helpers.font2(16.0, isDark ? white : black2, FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10000,
                    textAlign: TextAlign.justify,
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}