import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => EditProfileState();
}
class EditProfileState extends State<EditProfile> {
  var keyHeadView = GlobalKey();
  var keyBottomView = GlobalKey();
  Size? sizeHeadView;
  Size? sizeBottomView;
  bool isDark = false;
  bool isBahasaIndo = true;
  final formKeys = GlobalKey<FormState>();
  List formProfile = [
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.text,
      "titleID": LabelsID.labelNamaPengguna,
      "titleEN": LabelsEN.labelNamaPengguna,
      "errorMsgID":LabelsID.errorMessageNamaPengguna,
      "errorMsgEN":LabelsEN.errorMessageNamaPengguna,
      "hintID":LabelsID.hintNamaPengguna,
      "hintEN":LabelsEN.hintNamaPengguna,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.text,
      "titleID": LabelsID.labelNamaLengkap,
      "titleEN": LabelsEN.labelNamaLengkap,
      "errorMsgID":LabelsID.errorMessageNamaLengkap,
      "errorMsgEN":LabelsEN.errorMessageNamaLengkap,
      "hintID":LabelsID.hintNamaLengkap,
      "hintEN":LabelsEN.hintNamaLengkap,
    },
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
      "keyboardType": TextInputType.number,
      "titleID": LabelsID.labelNoHandphone,
      "titleEN": LabelsEN.labelNoHandphone,
      "errorMsgID": LabelsID.errorMessageNoHandphone,
      "errorMsgEN": LabelsEN.errorMessageNoHandphone,
      "hintID": LabelsID.hintNoHandphone,
      "hintEN": LabelsEN.hintNoHandphone,
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
      formProfile[0]["inpController"].text = prefs.getString("USERNAME") ?? '';
      formProfile[1]["inpController"].text = prefs.getString("NAME") ?? '';
      formProfile[2]["inpController"].text = prefs.getString("EMAIL") ?? '';
      formProfile[3]["inpController"].text = prefs.getString("PHONE") ?? '';
    });
  }
  void simpanData() async{
    if (formKeys.currentState!.validate()) {

    }
  }

  //CustomWidget
  Widget fieldProfile(isDark,isBahasaIndo,bottomMenuHeight,isKeyboardVisible) {
    var indexTerakhir = formProfile.length - 1;
    return Form(
        key: formKeys,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: formProfile.length,
            itemBuilder: (context, index){
              var inputForm = formProfile[index];
              bool? isObscure = inputForm["isObscure"];
              int maxLength_ = inputForm["maxLength"] ?? 1200;
              int maxLines_ = inputForm["maxLines"] ?? 1;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldDefault(
                    isDark: isDark,
                    maxLines: maxLines_,
                    itemKey: "value",
                    itemLabel: "label",
                    title: isBahasaIndo ? inputForm["titleID"] : inputForm["titleEN"],
                    hintText: isBahasaIndo ? inputForm["hintID"] : inputForm["hintEN"],
                    inputType: inputForm["keyboardType"],
                    maxLength: maxLength_,
                    selectedItem: inputForm["inpController"].text,
                    isObscure: isObscure ?? false,
                    onChanged: (value){
                      setState(() {
                        inputForm["inpController"].text = value;
                      });
                    },
                    suffixIcon: isObscure == null
                        ? null
                        : IconButton(
                      onPressed: () {
                        setState(() {
                          inputForm["isObscure"] = !isObscure;
                        });
                      },
                      icon: Icon(
                        isObscure
                            ? Elusive.eye
                            : Elusive.eye_off,
                        size: 24,
                        color: isObscure
                            ? black.withOpacity(0.4)
                            : basic,
                      ),
                    ),
                    inputController: inputForm["inpController"],
                    validator: (value) {
                      if (Helpers.stringValidate(value) == '') {
                        return isBahasaIndo ? inputForm["errorMsgID"] : inputForm["errorMsgEN"] ;
                      }
                      return null;
                    },
                  ),
                  if(index == indexTerakhir && !isKeyboardVisible)
                    SizedBox(
                      height: bottomMenuHeight,
                    )
                ],
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
                          label: isBahasaIndo ? LabelsID.labelUbahProfil.toUpperCase() : LabelsEN.labelUbahProfil.toUpperCase()
                      ),
                      Container(
                        width: screenWidth,
                        height: heightMenu,
                        padding: const EdgeInsets.all(0.0),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: fieldProfile(isDark,isBahasaIndo,bottomMenuHeight,isKeyboardVisible),
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