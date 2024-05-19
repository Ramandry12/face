import 'dart:async';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_information/device_information.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () => checkLoginSession());
    getImei();
  }

  void getImei() async {
    if(await Permission.phone.request().isGranted) {
     var imei = await DeviceInformation.deviceIMEINumber;
      log("imei info = $imei");
    }
  }
  void onNavigate(pages, parsingData) {
    Navigator.pushReplacementNamed(context, pages, arguments: parsingData);
  }
  void checkLoginSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('IS_LOGIN') ?? false;
    String isToken = prefs.getString('TOKEN').toString();
    if (isToken.isEmpty) {
      StateManager stateManager = StateManager();
      stateManager.setToken("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXMxMjNAZ21haWwuY29tIiwiZW1haWwiOiJ0ZXMxMjNAZ21haWwuY29tIiwiZXhwIjoxOTE4NTQ3MTQyfQ.5rQF9_VkoTzXWhO75knLI3xsArO3VdZCguVduiDz-U0");
    }

    if(isLogin){
      onNavigate("/Home", "");
    }
    else{
      onNavigate("/Login", "");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          color: basic,
          width: screenWidth,
          height: screenHeight,
          child: Image.asset(
            "assets/logo/bg.png",
            width: screenWidth * .975,
            height: screenWidth * .975,
            fit: BoxFit.fill,
            gaplessPlayback: true,
            filterQuality: FilterQuality.medium,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ImageLogo(
                width: screenWidth * .4,
              ),

            ],
          ),
        )
      ],
    );
  }
}
