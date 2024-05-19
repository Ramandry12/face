import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  var keyHeadView = GlobalKey();
  var keyBottomView = GlobalKey();
  final controllerSearch = TextEditingController();
  Size? sizeHeadView;
  Size? sizeBottomView;
  bool isDark = false;
  bool isBahasaIndo = true;
  List<dynamic> listItemRecentSearch = [];
  List<dynamic> listItemRecentSearchFiltered = [];
  File? image_;
  CroppedFile? _croppedFile;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          sizeHeadView = Helpers.getBoxSize(keyHeadView.currentContext!);
          sizeBottomView = Helpers.getBoxSize(keyBottomView.currentContext!);
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

  void setStateManager() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('IS_DARK') ?? false;
      isBahasaIndo = prefs.getBool('IS_BAHASA') ?? true;
      listItemRecentSearch =
          jsonDecode(prefs.getString('RECENT_SEARCH') ?? '[]');
      listItemRecentSearchFiltered =
          jsonDecode(prefs.getString('RECENT_SEARCH') ?? '[]');
    });
  }

  Future<void> onCamera(context) async {
    XFile? image = await Helpers.onGetCamera(context, isBahasaIndo, isDark);
    if (image == null) return;
    File file = File(image.path);

    await _cropImage(file);
    print("Gambar yang dipotong: $image_");
    setState(() {
      image_ = File(_croppedFile!.path);
    });
  }

  Future<void> _cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Potong Gambar',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Potong Gambar',
        ),
        WebUiSettings(
          context: context, // Pastikan Anda memiliki akses ke variabel context
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 520,
            height: 520,
          ),
          viewPort: const CroppieViewPort(
            width: 480,
            height: 480,
            type: 'circle',
          ),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _croppedFile = croppedFile;
        image_ = File(_croppedFile!
            .path); // Simpan gambar yang dipotong di dalam variabel image_
        print("imageeeeee $image_");
      });
    }
  }

  void bottomSheetPilihGambar() async {
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
          MainButtonIcon(
            onPressed: () async {
              await onCamera(context);
              if (image_ != null && _croppedFile != null) {
                onNavigate('/FindPage', {
                  "tipe": "FindMany",
                  "image": image_,
                  "croppedFile": _croppedFile,
                });
              } else {
                print("yah gagal");
              }
            },
            iconButton: Icons.camera_alt_rounded,
            label: "Pilih dari kamera",
            fontStyle: Helpers.font1(15.0, white, FontWeight.w400),
          ),
        ],
      ),
    );
  }

  //CustomWidget
  Widget listRecentSearch(width_, height_) {
    var fontColor = isDark ? white : black;
    var spaceBar = Helpers.onSpaceBar(context);
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;
    if (listItemRecentSearchFiltered.isNotEmpty ||
        listItemRecentSearchFiltered.isEmpty) {
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
          color: isDark ? transparent : white,
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
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: listItemRecentSearchFiltered.length,
          itemBuilder: (context, index) {
            var itemRecent_ = listItemRecentSearchFiltered[index];
            var indexTerakhir = listItemRecentSearchFiltered.length - 1;
            return ButtonPinch(
              onPressed: () {
                onNavigate('/PageDetail', {
                  "tipe": "PageDetail",
                  "response": listItemRecentSearchFiltered,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: Helpers.onRadius(1, defaultPaddingContain),
                      child: Image.memory(
                        base64Decode(itemRecent_["personDetail"]["imageUrl"]),
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
                          itemRecent_["personDetail"]["nama"],
                          style:
                              Helpers.font1(14.0, fontColor, FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          itemRecent_["personDetail"]["nik"],
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
            child: KeyboardVisibilityBuilder(
              builder: (context, isKeyboardVisible) {
                return Stack(
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/img/search.png",
                                          width: defaultSizeIcon,
                                          height: defaultSizeIcon,
                                        ),
                                        const SizedBox(
                                          width: defaultPadding / 2,
                                        ),
                                        Text(
                                          isBahasaIndo
                                              ? LabelsID.labelFaceSearch
                                              : LabelsEN.labelFaceSearch,
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
                                          ? LabelsID.labelFaceSomeoneImgorID
                                          : LabelsEN.labelFaceSomeoneImgorID,
                                      style: Helpers.font2(
                                          15.0,
                                          isDark ? gray : black2,
                                          FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: defaultPadding / 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MainButtonIcon(
                                          onPressed: () => {
                                            bottomSheetPilihGambar(),
                                          },
                                          iconButton: Icons.camera_enhance,
                                          width: ((screenWidth -
                                                      defaultPadding * 2) /
                                                  2) -
                                              (defaultPadding / 2),
                                          label: isBahasaIndo
                                              ? LabelsID.labelCamera
                                              : LabelsEN.labelCamera,
                                          fontStyle: Helpers.font1(
                                              12.0, white, FontWeight.w400),
                                        ),
                                        MainButtonIcon(
                                          onPressed: () =>
                                              onNavigate('/FindPage', {
                                            "tipe": "findSome",
                                          }),
                                          iconButton: Icons.people,
                                          width: ((screenWidth -
                                                      defaultPadding * 2) /
                                                  2) -
                                              (defaultPadding / 2),
                                          label: isBahasaIndo
                                              ? LabelsID.labelCariBeberapa
                                              : LabelsEN.labelCariBeberapa,
                                          fontStyle: Helpers.font1(
                                              14.0, white, FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: defaultPadding / 2,
                                    ),
                                    // MainButtonIcon(
                                    //   onPressed: () =>
                                    //       onNavigate('/LiveTagging', {
                                    //     "tipe": "findSome",
                                    //   }),
                                    //   iconButton: Icons.face_2_outlined,
                                    //   width:
                                    //       ((screenWidth - defaultPadding * 2) /
                                    //               2) -
                                    //           (defaultPadding / 2),
                                    //   label: isBahasaIndo
                                    //       ? LabelsID.labelLiveTagging
                                    //       : LabelsEN.labelLiveTagging,
                                    //   fontStyle: Helpers.font1(
                                    //       14.0, white, FontWeight.w400),
                                    // ),
                                    const SizedBox(height: defaultPadding / 2),
                                    TextFieldDefault(
                                      isDark: isDark,
                                      hintText: isBahasaIndo
                                          ? LabelsID.hintPencarianTerkini
                                          : LabelsEN.hintPencarianTerkini,
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
                                            listItemRecentSearchFiltered =
                                                listItemRecentSearch;
                                          });
                                        } else {
                                          setState(() {
                                            listItemRecentSearchFiltered =
                                                listItemRecentSearch
                                                    .where((item) =>
                                                        item["personDetail"]
                                                                ["nama"]
                                                            .toLowerCase()
                                                            .contains(value
                                                                .toLowerCase()))
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
                                      padding: const EdgeInsets.all(
                                          defaultPadding * 0.6),
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
                                            ? LabelsID.pencarianTerkini
                                            : LabelsEN.pencarianTerkini,
                                        style: Helpers.font1(
                                            15.0,
                                            isDark ? gray : black2,
                                            FontWeight.w600),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    listRecentSearch(
                                        screenWidth - defaultPadding * 2,
                                        (screenWidth - defaultPadding * 2) /
                                            3.5),
                                    SizedBox(
                                      height: (sizeBottomView?.height ?? 0),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                    if (!isKeyboardVisible)
                      BottomNavigationMenu(
                        keyBottomNavigation: keyBottomView,
                        isDark: isDark,
                        activeItem: "search",
                        isBahasaIndo: isBahasaIndo,
                        width: screenWidth,
                        height: (screenWidth * 0.15) + defaultPadding * 2,
                      )
                  ],
                );
              },
            )));
  }
}
