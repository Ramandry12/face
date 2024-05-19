import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}
class RegisterScreenState extends State<RegisterScreen> {
  var keyHeadView = GlobalKey();
  var keyBottomView = GlobalKey();
  Size? sizeHeadView;
  Size? sizeBottomView;
  bool isDark = false;
  bool isBahasaIndo = true;
  final formKeys = GlobalKey<FormState>();
  List formRegister = [
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.number,
      "iconInput":Entypo.credit_card,
      "maxLength":12,
      "titleID": LabelsID.labelNIK,
      "titleEN": LabelsEN.labelNIK,
      "errorMsgID":LabelsID.errorMessageNIK,
      "errorMsgEN":LabelsEN.errorMessageNIK,
      "hintID":LabelsID.hintNIK,
      "hintEN":LabelsEN.hintNIK,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.text,
      "iconInput":Icons.person,
      "titleID": LabelsID.labelTempatLahir,
      "titleEN": LabelsEN.labelNamaLengkap,
      "errorMsgID":LabelsID.errorMessageNamaLengkap,
      "errorMsgEN":LabelsEN.errorMessageNamaLengkap,
      "hintID":LabelsID.hintNamaLengkap,
      "hintEN":LabelsEN.hintNamaLengkap,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.text,
      "iconInput":Icons.pin_drop,
      "titleID": LabelsID.labelTempatLahir,
      "titleEN": LabelsEN.labelTempatLahir,
      "errorMsgID":LabelsID.errorMessageTempatLahir,
      "errorMsgEN":LabelsEN.errorMessageTempatLahir,
      "hintID":LabelsID.hintTempatLahir,
      "hintEN":LabelsEN.hintTempatLahir,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": TextInputType.text,
      "iconInput":Entypo.home,
      "titleID": LabelsID.labelAlamat,
      "titleEN": LabelsEN.labelAlamat,
      "maxLines":2,
      "errorMsgID":LabelsID.errorMessageAlamat,
      "errorMsgEN":LabelsEN.errorMessageAlamat,
      "hintID":LabelsID.hintAlamat,
      "hintEN":LabelsEN.hintAlamat,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": "datePicker",
      "iconInput":Icons.date_range,
      "titleID": LabelsID.labelTanggalLahir,
      "titleEN": LabelsEN.labelTanggalLahir,
      "errorMsgID":LabelsID.errorMessageTanggalLahir,
      "errorMsgEN":LabelsEN.errorMessageTanggalLahir,
      "hintID":LabelsID.hintTanggalLahir,
      "hintEN":LabelsEN.hintTanggalLahir,
    },
    {
      "inpController": TextEditingController(),
      "keyboardType": "dropDown",
      "iconInput":Icons.people,
      "titleID": LabelsID.labelJenisKelamin,
      "titleEN": LabelsEN.labelJenisKelamin,
      "errorMsgID":LabelsID.errorMessageJenisKelamin,
      "errorMsgEN":LabelsEN.errorMessageJenisKelamin,
      "hintID":LabelsID.hintJenisKelamin,
      "hintEN":LabelsEN.hintJenisKelamin,
    },
  ];
  List<dynamic> itemJenisKelamin = [
    {
      "value":"Laki-Laki",
      "label": LabelsID.labelLakilaki
    },
    {
      "value":"Perempuan",
      "label": LabelsID.labelPerempuan,
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
  void onRegister(){
    if(formKeys.currentState!.validate()){
      String nik = formRegister[0]["inpController"].text;
      String name = formRegister[1]["inpController"].text;
      String tempatLahir = formRegister[2]["inpController"].text;
      String alamat = formRegister[3]["inpController"].text;
      String tanggalLahir = formRegister[4]["inpController"].text;
      String jenisKelamin = formRegister[5]["inpController"].text;
      registerServis(nik,name,tempatLahir,alamat,tanggalLahir,jenisKelamin);
    }
  }
  void setStateManager() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('IS_DARK') ?? false;
      isBahasaIndo = prefs.getBool('IS_BAHASA') ?? true;
    });
  }

  //CustomWidget
  Widget registerForm(isDark,isBahasaIndo,bottomMenuHeight,isKeyboardVisible) {
    var indexTerakhir = formRegister.length - 1;
    return Form(
        key: formKeys,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: formRegister.length,
            itemBuilder: (context, index){
              var inputForm = formRegister[index];
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
                    itemList: itemJenisKelamin,
                    isObscure: isObscure ?? false,
                    onChanged: (value){
                      setState(() {
                        inputForm["inpController"].text = value;
                      });
                    },
                    prefixIcon: Icon(
                      inputForm["iconInput"],
                      size: defaultSizeIcon ,
                      color: isDark ? gray.withOpacity(0.5) : basic.withOpacity(0.5),
                    ),
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

  //Servis API
  void registerServis(nik,name,tempatLahir,alamat,tanggalLahir,jenisKelamin) async{

  }

  @override
  Widget build(BuildContext context) {
    var spaceBar = Helpers.onSpaceBar(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;
    var bottomMenuHeight = (sizeBottomView?.height ?? 0);
    var heightMenu = screenHeight - (sizeHeadView?.height ?? 0);
    var fontColor = isDark ? white :  black;
    var formRegisterColorContainer = isDark ? black2 : white;
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
                          label: isBahasaIndo ? LabelsID.labelDaftarButton : LabelsEN.labelDaftarButton
                      ),
                      Container(
                          width: screenWidth,
                          height: heightMenu,
                          padding: const EdgeInsets.all(0.0),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: registerForm(isDark,isBahasaIndo,bottomMenuHeight,isKeyboardVisible),
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
                        color:formRegisterColorContainer,
                        boxShadow: [
                          BoxShadow(
                            color: black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child:Column(
                        children: [
                          MainButtonText(
                            onPressed:(){},
                            label: isBahasaIndo ? LabelsID.labelDaftarButton : LabelsEN.labelDaftarButton,
                            fontStyle: Helpers.font1(15.0, white, FontWeight.w600),
                          ),
                          const SizedBox(
                            height: defaultPadding/2,
                          ),
                          Row(
                            children: [
                              Text(
                                isBahasaIndo ? LabelsID.labelSudahPunyaAkun : LabelsEN.labelSudahPunyaAkun,
                                style: Helpers.font1(15.0, fontColor, FontWeight.w400),
                                maxLines: 4,
                                textAlign: TextAlign.center,
                              ),
                              ButtonPinch(
                                onPressed:goBack,
                                scale: 0.95,
                                boxColor: transparent,
                                isShadow: false,
                                isBorder: false,
                                enable: true,
                                paddingChild: const EdgeInsets.all(0.0),
                                child: Text(
                                  isBahasaIndo ? LabelsID.labelLoginDisini : LabelsEN.labelLoginDisini,
                                  style: Helpers.font1(15.0, basic, FontWeight.w400),
                                  maxLines: 4,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          )
                        ],
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