import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<EditPassword> createState() => EditPasswordState();
}
class EditPasswordState extends State<EditPassword> {
  var keyHeadView = GlobalKey();
  var keyBottomView = GlobalKey();
  Size? sizeHeadView;
  Size? sizeBottomView;
  bool isDark = false;
  bool isBahasaIndo = true;
  final formKeys = GlobalKey<FormState>();
  List itemFieldChagePassword = [
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.visiblePassword,
      "titleID": LabelsID.labelPasswordSekarang,
      "titleEN": LabelsEN.labelPasswordSekarang,
      "isObscure": true,
      "errorMsgID": LabelsID.errorMessagePassword,
      "errorMsgEN": LabelsEN.errorMessagePassword,
      "hintID": LabelsID.hintPassword,
      "hintEN": LabelsEN.hintPassword,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.visiblePassword,
      "titleID": LabelsID.labelPasswordBaru,
      "titleEN": LabelsEN.labelPasswordBaru,
      "isObscure": true,
      "errorMsgID": LabelsID.errorMessagePassword,
      "errorMsgEN": LabelsEN.errorMessagePassword,
      "hintID": LabelsID.hintPassword,
      "hintEN": LabelsEN.hintPassword,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.visiblePassword,
      "titleID": LabelsID.labelPasswordBaruKonfirmasi,
      "titleEN": LabelsEN.labelPasswordBaruKonfirmasi,
      "isObscure": true,
      "errorMsgID": LabelsID.errorMessagePassword,
      "errorMsgEN": LabelsEN.errorMessagePassword,
      "hintID": LabelsID.hintPassword,
      "hintEN": LabelsEN.hintPassword,
    },
  ];

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
  void simpanData() async{
    if (formKeys.currentState!.validate()) {

    }
  }

  //CustomWidget
  Widget fieldPassword(isDark,isBahasaIndo,bottomMenuHeight,isKeyboardVisible) {
    return Form(
        key: formKeys,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemFieldChagePassword.length,
            itemBuilder: (context, index){
              var inputForm = itemFieldChagePassword[index];
              bool? isObscure = inputForm["isObscure"];
              return TextFieldDefault(
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
              );
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    var spaceBar = Helpers.onSpaceBar(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;
    var bottomMenuHeight = (sizeBottomView?.height ?? 0);
    var heightMenu = screenHeight - (sizeHeadView?.height ?? 0);
    var containerEditProfile = isDark ? black2 : white;
    return Background(
        isDarkTheme: isDark,
        child: KeyboardVisibilityBuilder(
          builder: (context,isKeyboardVisible){
            return Stack(
              children: [
                SingleChildScrollView(
                  physics: isKeyboardVisible ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBarText(
                          keyAppBar: keyHeadView,
                          onPressed: goBack,
                          isDark: isDark,
                          label: isBahasaIndo ? LabelsID.labelUbahKataSandi.toUpperCase() : LabelsEN.labelUbahKataSandi.toUpperCase()
                      ),
                      Container(
                        width: screenWidth,
                        height: heightMenu,
                        padding: const EdgeInsets.all(0.0),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: fieldPassword(isDark,isBahasaIndo,bottomMenuHeight,isKeyboardVisible),
                        ),
                      )
                    ],
                  ),
                ),
                if(!isKeyboardVisible)
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child:Container(
                        key: keyBottomView,
                        width: screenWidth,
                        padding: const EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          borderRadius: Helpers.onRadius(3, defaultPadding),
                          color:containerEditProfile,
                          boxShadow: [
                            BoxShadow(
                              color: black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child:MainButtonText(
                          onPressed:simpanData,
                          label: isBahasaIndo ? LabelsID.labelSimpanBtn : LabelsEN.labelSimpanBtn,
                          fontStyle: Helpers.font1(15.0, white, FontWeight.w600),
                        ),
                      )
                  ),
              ],
            );
          },
        )
    );
  }
}