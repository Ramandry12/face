import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}
class ProfileScreenState extends State<ProfileScreen> {
  var keyHeadView = GlobalKey();
  var keyBottomView = GlobalKey();
  final formKeysPilihBahasa = GlobalKey<FormState>();
  final formKeysPilihTema = GlobalKey<FormState>();
  final formKeysUbahPassword = GlobalKey<FormState>();
  Size? sizeHeadView;
  Size? sizeBottomView;
  String namaUser ="";
  bool isDark = false;
  bool isBahasaIndo = true;
  String pilihanBahasa ="";
  String pilihanTema ="";
  List menuProfileItem = [
    {
      "id":1,
      "icon":Icons.edit_rounded,
      "labelID":LabelsID.labelUbahProfil,
      "labelEN":LabelsEN.labelUbahProfil,
    },
    {
      "id":6,
      "icon":Icons.lock,
      "labelID":LabelsID.labelUbahKataSandi,
      "labelEN":LabelsEN.labelUbahKataSandi,
    },
    {
      "id":2,
      "icon":Icons.language,
      "labelID":LabelsID.labelUbahBahasa,
      "labelEN":LabelsEN.labelUbahBahasa,
    },
    // {
    //   "id":3,
    //   "icon":Icons.dark_mode,
    //   "labelID":"Tema",
    //   "labelEN":"Theme",
    // },
    {
      "id":4,
      "icon":Icons.info,
      "labelID":LabelsID.labelTentang,
      "labelEN":LabelsEN.labelTentang,
    },
    {
      "id":5,
      "icon":Icons.exit_to_app,
      "labelID":LabelsID.labelKeluar,
      "labelEN":LabelsEN.labelKeluar,
    },
  ];
  List itemBahasa =[
    {
      "label":"INDONESIA",
      "value":"true",
    },
    {
      "label":"ENGLISH",
      "value":"false",
    }
  ];
  List itemTema =[
    {
      "label":"DARK MODE",
      "value":"true",
    },
    {
      "label":"LIGHT MODE",
      "value":"false",
    }
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
      namaUser = prefs.getString("NAME") ?? '';
    });
  }
  void bottomSheetPilihBahasa() async {
    setState(() {
      pilihanBahasa = "";
    });
    bottomSheetDialog(
        context,
        isDark,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            Text(
              isBahasaIndo ? LabelsID.labelPilihBahasa: LabelsEN.labelPilihBahasa,
              style: Helpers.font1(15.0, isDark ? white : black, FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Form(
                key: formKeysPilihBahasa,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter stateSet) {
                      return ModalSearch(
                        isDark: isDark,
                        hintTitle: isBahasaIndo ? LabelsID.labelPilihBahasaAnda: LabelsEN.labelPilihBahasaAnda,
                        fit: FlexFit.loose,
                        items: itemBahasa,
                        onChanged:(val){
                          setState(() {
                            pilihanBahasa = val;
                          });
                          stateSet(() {
                            pilihanBahasa = val;
                          });
                        },
                        selectedItem: pilihanBahasa,
                        showSearchBox: false,
                        typePop: "pop",
                        itemKey: "value",
                        itemLabel: "label",
                        enableReset: false,
                        validator: (value) {
                          if (Helpers.stringValidate(value) == '') {
                            return isBahasaIndo ? LabelsID.errorMessagePilihBahasa: LabelsEN.errorMessagePilihBahasa;
                          }
                          return null;
                        },
                      );
                    }
                )
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            MainButtonText(
              onPressed:(){
                if(formKeysPilihBahasa.currentState!.validate()){
                  bool choosenLang = pilihanBahasa.toLowerCase() == "true";
                  setState(() {
                    isBahasaIndo = choosenLang;
                  });
                  StateManager stateManager = StateManager();
                  stateManager.setBahasa(choosenLang);
                  Navigator.of(context).pop();
                }
              },
              label:isBahasaIndo ? LabelsID.labelSimpan: LabelsEN.labelSimpan,
              fontStyle: Helpers.font1(15.0, white, FontWeight.w600),
            ),
          ],
        )
    );
  }
  void onNavigate(pages, parsingData) {
    Navigator.pushNamed(context, pages, arguments: parsingData);
  }
  void bottomSheetPilihTema() async {
    setState(() {
      pilihanTema = "";
    });
    bottomSheetDialog(
        context,
        isDark,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            Text(
              isBahasaIndo ? LabelsID.labelPilihTema: LabelsEN.labelPilihTema,
              style: Helpers.font1(15.0, isDark ? white : black, FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Form(
                key: formKeysPilihTema,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter stateSet) {
                      return ModalSearch(
                        isDark: isDark,
                        hintTitle: isBahasaIndo ? LabelsID.labelPilihTemaAnda: LabelsEN.labelPilihTemaAnda,
                        fit: FlexFit.loose,
                        items: itemTema,
                        onChanged:(val){
                          setState(() {
                            pilihanTema = val;
                          });
                          stateSet(() {
                            pilihanTema = val;
                          });
                        },
                        selectedItem: pilihanTema,
                        showSearchBox: false,
                        typePop: "pop",
                        itemKey: "value",
                        itemLabel: "label",
                        enableReset: false,
                        validator: (value) {
                          if (Helpers.stringValidate(value) == '') {
                            return isBahasaIndo ? LabelsID.errorMessagePilihTema: LabelsEN.errorMessagePilihTema;
                          }
                          return null;
                        },
                      );
                    }
                )
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            MainButtonText(
              onPressed:(){
                if(formKeysPilihTema.currentState!.validate()){
                  bool choosenTheme = pilihanTema.toLowerCase() == "true";
                  setState(() {
                    isDark = choosenTheme;
                  });
                  StateManager stateManager = StateManager();
                  stateManager.setDarkMode(choosenTheme);
                  Navigator.of(context).pop();
                }
              },
              label:isBahasaIndo ? LabelsID.labelSimpan: LabelsEN.labelSimpan,
              fontStyle: Helpers.font1(15.0, white, FontWeight.w600),
            ),
          ],
        )
    );
  }
  void logoutAkun() async{
    Helpers.showAlert(
      context,
      AlertGlobal(
        isDark: isDark,
        isBahasaIndo: isBahasaIndo,
        labelPress: isBahasaIndo ? LabelsID.label_yes : LabelsEN.label_yes,
        onPress: (){
          StateManager stateManager = StateManager();
          stateManager.setLogoutSession();
          onNavigate("/Login", "");
        },
        onCatch: (){},
        labelCatch: isBahasaIndo ? LabelsID.label_tidak : LabelsEN.label_tidak,
        desc: isBahasaIndo ? LabelsID.labelAlertExit : LabelsEN.labelAlertExit,
        enableBack: true,
      ),
    );
  }

  //CustomWidget
  Widget menuProfile(width_,height_) {
    var fontColor = isDark ? white :  black;
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: menuProfileItem.length,
        itemBuilder: (context, index){
          var menuProfileItem_ = menuProfileItem[index];
          return ButtonPinch(
            onPressed:(){
              if(menuProfileItem_["id"] == 1){
                //Ubah Profil
                onNavigate("/EditProfile", "");
              }
              else if(menuProfileItem_["id"] == 2){
                //Ubah Bahasa
                bottomSheetPilihBahasa();
              }
              else if(menuProfileItem_["id"] == 3){
                //Ubah Tema
                bottomSheetPilihTema();
              }
              else if(menuProfileItem_["id"] == 4){
                //Tentang Aplikasi
                onNavigate("/AboutPage", "");
              }
              else if(menuProfileItem_["id"] == 5){
                //Keluar Akun
                logoutAkun();
              }
              else if(menuProfileItem_["id"] == 6){
                onNavigate("/EditPassword", "");
              }
            },
            scale: 0.95,
            boxColor: transparent,
            isShadow: false,
            radius: 0,
            isBorder: false,
            enable: true,
            paddingChild: const EdgeInsets.all(0.0),
            child: SizedBox(
              width: width_,
              height: height_,
              // decoration: BoxDecoration(
              //   border: Border(
              //     bottom: BorderSide(
              //       color: index == indexTerakhir
              //           ? isDark ? black : white
              //           : isDark ? white : gray,
              //       width: index == indexTerakhir ? 0.0 : 0.3, // Ubah nilai ini untuk mengatur ketebalan garis bawah
              //     ),
              //   ),
              //   color: isDark ? black : white,
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        menuProfileItem_["icon"],
                        size: (height_)/3,
                        color: isDark ? white : black2,
                      ),
                      const SizedBox(
                        width: defaultPadding/2,
                      ),
                      Text(
                        isBahasaIndo ? menuProfileItem_["labelID"] : menuProfileItem_["labelEN"],
                        style: Helpers.font1(15.0, fontColor, FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: defaultSizeIcon,
                    color: isDark ? white : black2,
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  Widget cardProfile(width_,height_) {
    var fontColor = isDark ? white :  black;
    return Container(
      width: width_,
      // height: height_,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        borderRadius: Helpers.onRadius(1, defaultPadding),
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
      child: Column(
        children: [
          SizedBox(
            width: width_ -  defaultPadding*2,
            height: ((height_ - defaultPadding*2)/2) - (defaultPadding/2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: Helpers.onRadius(1, defaultPaddingContain),
                  child: Image.asset(
                    "assets/logo/dummy_pict.png",
                    width: ((height_ - defaultPadding*2)/2) - (defaultPadding/2),
                    height: ((height_ - defaultPadding*2)/2) - (defaultPadding/2),
                    fit: BoxFit.contain,
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
                      "Hi $namaUser",
                      style: Helpers.font1(20.0, isDark ? white : black2, FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      "Have a great days",
                      style: Helpers.font2(20.0, isDark ? white : black2, FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),
                  ],
                )
              ],
            ),
          ),
          // SizedBox(
          //   width: width_ -  defaultPadding*2,
          //   height: ((height_ - defaultPadding*2)/2) - (defaultPadding/2),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Container(
          //         width: ((width_ -  defaultPadding*2)/2) - defaultPadding/2,
          //         height: ((height_ - defaultPadding*2)/2) - (defaultPadding/2),
          //         decoration: BoxDecoration(
          //           borderRadius: Helpers.onRadius(1, defaultPadding/2),
          //           color: basic,
          //           boxShadow: [
          //             BoxShadow(
          //               color: black.withOpacity(0.3),
          //               spreadRadius: 1,
          //               blurRadius: 1,
          //               offset: const Offset(0, 2),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Container(
          //         width: ((width_ -  defaultPadding*2)/2) - defaultPadding/2,
          //         height: ((height_ - defaultPadding*2)/2) - (defaultPadding/2),
          //         decoration: BoxDecoration(
          //           borderRadius: Helpers.onRadius(1, defaultPadding/2),
          //           color: basic,
          //           boxShadow: [
          //             BoxShadow(
          //               color: black.withOpacity(0.3),
          //               spreadRadius: 1,
          //               blurRadius: 1,
          //               offset: const Offset(0, 2),
          //             ),
          //           ],
          //         ),
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var spaceBar = Helpers.onSpaceBar(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;
    var heightMenu = screenHeight - (sizeHeadView?.height ?? 0);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Background(
          isDarkTheme: isDark,
          child:Stack(
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

                              // Card Profile
                              cardProfile(screenWidth - defaultPadding*2, (screenWidth - defaultPadding*2)/1.5),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              menuProfile(screenWidth - defaultPadding*2,(screenWidth - defaultPadding*2) * 0.17),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              Text(
                                "Versi 1.0.0",
                                style: Helpers.font2(15.0, isDark ? white : gray, FontWeight.w400),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: (sizeBottomView?.height ?? 0),
                              )
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ),
              BottomNavigationMenu(
                keyBottomNavigation: keyBottomView,
                isDark: isDark,
                activeItem:"profile",
                isBahasaIndo: isBahasaIndo,
                width: screenWidth,
                height: (screenWidth*0.15)+defaultPadding*2,
              )
            ],
          )
      ),
    );
  }
}