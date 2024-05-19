import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final formKeys = GlobalKey<FormState>();
  final formKeysResetPassword = GlobalKey<FormState>();
  final controllerEmailReset = TextEditingController();
  List formLogin = [
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.emailAddress,
      "titleID": "Email",
      "titleEN": "Email",
      "errorMsgID": LabelsID.errorMessageEmail,
      "errorMsgEN": LabelsEN.errorMessageEmail,
      "hintID": LabelsID.hintEmail,
      "hintEN": LabelsEN.hintEmail,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.visiblePassword,
      "titleID": LabelsID.labelPassword,
      "titleEN": LabelsEN.labelPassword,
      "isObscure": true,
      "errorMsgID": LabelsID.errorMessagePassword,
      "errorMsgEN": LabelsEN.errorMessagePassword,
      "hintID": LabelsID.hintPassword,
      "hintEN": LabelsEN.hintPassword,
    },
  ];
  bool isDark = false;
  bool isBahasaIndo = true;
  bool showSpinner = false;

  @override
  void initState() {
    setStateManager();
    super.initState();
  }

  //Default Function
  void onNavigate(pages, parsingData) {
    Navigator.pushNamed(context, pages, arguments: parsingData);
  }

  void onLogin() {
    if (formKeys.currentState!.validate()) {
      String email = formLogin[0]["inpController"].text;
      String password = formLogin[1]["inpController"].text;
      loginServis(email, password);
    }
  }

  void onRegister() => onNavigate("/Register", "");

  void setStateManager() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('IS_DARK') ?? false;
      isBahasaIndo = prefs.getBool('IS_BAHASA') ?? true;
    });
  }

  void bottomSheetLupaPassword() async {
    var spaceBar = Helpers.onSpaceBar(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;
    bottomSheetDialog(context, isDark, KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            Text(
              isBahasaIndo
                  ? LabelsID.labelForgotPassword
                  : LabelsEN.labelForgotPassword,
              style:
                  Helpers.font1(15.0, isDark ? white : black, FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Form(
              key: formKeysResetPassword,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFieldDefault(
                isDark: isDark,
                hintText:
                    isBahasaIndo ? LabelsID.hintEmail : LabelsEN.hintEmail,
                title: "Email",
                inputType: TextInputType.emailAddress,
                inputController: controllerEmailReset,
                validator: (value) {
                  if (Helpers.stringValidate(value) == '') {
                    return "";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            MainButtonText(
              onPressed: () {
                if (formKeysResetPassword.currentState!.validate()) {}
              },
              label: isBahasaIndo ? LabelsID.labelSubmit : LabelsEN.labelSubmit,
              fontStyle: Helpers.font1(15.0, white, FontWeight.w600),
            ),
            if (isKeyboardVisible)
              SizedBox(
                height: screenHeight * .38,
              )
          ],
        );
      },
    ));
  }

  //CustomWidget
  Widget loginForm(isDark, isBahasaIndo) {
    var screenWidth = (MediaQuery.of(context).size.width) - defaultPadding * 2;
    return Form(
        key: formKeys,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: formLogin.length,
            itemBuilder: (context, index) {
              var inputForm = formLogin[index];
              bool? isObscure = inputForm["isObscure"];
              var indexTerakhir = formLogin.length - 1;
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
                    inputType: inputForm["keyboardType"],
                    isObscure: isObscure ?? false,
                    suffixIcon: isObscure == null
                        ? null
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                inputForm["isObscure"] = !isObscure;
                              });
                            },
                            icon: Icon(
                              isObscure ? Elusive.eye : Elusive.eye_off,
                              size: 24,
                              color: isObscure ? black.withOpacity(0.4) : basic,
                            ),
                          ),
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
                  if (index == indexTerakhir)
                    Container(
                      width: screenWidth,
                      alignment: Alignment.centerRight,
                      child: ButtonPinch(
                        onPressed: () {
                          bottomSheetLupaPassword();
                        },
                        scale: 0.95,
                        boxColor: transparent,
                        isShadow: false,
                        isBorder: false,
                        enable: true,
                        paddingChild: const EdgeInsets.all(0.0),
                        child: Text(
                          isBahasaIndo
                              ? LabelsID.labelLupaPassword
                              : LabelsEN.labelLupaPassword,
                          style: Helpers.font1(13.0, basicC, FontWeight.w400),
                          maxLines: 4,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    )
                ],
              );
            }));
  }

  //Servis API
  void loginServis(email, password) async {
    final url = FRServer.hostServer + Endpoint.login;
    FormData body = FormData.fromMap({
      'email': email,
      'password': password,
    });
    setState(() {
      showSpinner = true;
    });
    Api().servicePost(url, body).then((response) async {
      setState(() {
        showSpinner = false;
      });
      if (response["statusCode"] < 300) {
        UserModel userModel = UserModel.fromJson(response["data"]["userDTO"]);
        StateManager stateManager = StateManager();
        stateManager.setLoginSession(true, userModel);
        stateManager.setToken(response["data"]["token"]);
        onNavigate("/Home", "");
      } else {
        Helpers.viewToast(response["data"]["message"], 3);
      }
    }).catchError((e) {
      setState(() {
        showSpinner = false;
      });
      Helpers.viewToast(e.toString(), 3);
    });
  }

  @override
  Widget build(BuildContext context) {
    var spaceBar = Helpers.onSpaceBar(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;
    var fontColor = isDark ? white : black;
    var formLoginColorContainer = isDark ? black2 : white;
    return Background(
        isDarkTheme: isDark,
        isShowSpinner: showSpinner,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                height: screenHeight / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ImageLogo(
                      isDark: isDark,
                      width: screenWidth * .4,
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Text(
                      isBahasaIndo
                          ? LabelsID.labelSelamatDatang
                          : LabelsEN.labelSelamatDatang,
                      style: Helpers.font1(20.0, fontColor, FontWeight.w400),
                      maxLines: 4,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: defaultPadding / 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: defaultPadding, right: defaultPadding),
                      child: Text(
                        isBahasaIndo
                            ? LabelsID.loginIntro
                            : LabelsEN.loginIntro,
                        style: Helpers.font2(12.0, fontColor, FontWeight.w400),
                        maxLines: 4,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  width: screenWidth,
                  height: screenHeight / 2,
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      loginForm(isDark, isBahasaIndo),
                      const SizedBox(
                        height: defaultPadding * 2,
                      ),
                      MainButtonText(
                        onPressed: onLogin,
                        label: isBahasaIndo
                            ? LabelsID.labelMasukButton
                            : LabelsEN.labelMasukButton,
                        fontStyle: Helpers.font1(15.0, white, FontWeight.w600),
                        bgColor: basicF,
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
