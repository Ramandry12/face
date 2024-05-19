import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Helpers {
  static showAlert(context, pageBuild) {
    if (pageBuild == null) {
      return Navigator.pop(context);
    } else {
      bool? curAlert = ModalRoute.of(context)?.isCurrent;
      if (curAlert == false) {
        // dismiss current alert
        Navigator.pop(context);
      }

      return Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, a, b) => pageBuild,
        opaque: false,
        transitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (_, a, __, b) =>
            FadeTransition(opacity: a, child: b),
      ));
    }
  }

  static showAlertModal(context, pageBuild) {
    if (pageBuild == null) {
      return Navigator.pop(context);
    } else {
      return Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, a, b) => pageBuild,
        opaque: false,
        transitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (_, a, __, b) =>
            FadeTransition(opacity: a, child: b),
      ));
    }
  }

  static viewToast(label, int position) {
    var gravities = ToastGravity.CENTER;
    if (position == 1) {
      gravities = ToastGravity.CENTER;
    } else if (position == 2) {
      gravities = ToastGravity.TOP;
    } else {
      gravities = ToastGravity.BOTTOM;
    }

    return Fluttertoast.showToast(
      msg: label,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravities,
      timeInSecForIosWeb: 1,
      backgroundColor: black.withOpacity(0.65),
      textColor: white,
      fontSize: 16.0,
    );
  }

  static font1(double size, color, weight) {
    return GoogleFonts.poppins(
      fontSize: size.toDouble(),
      color: color ?? black,
      fontWeight: weight ?? FontWeight.w500,
    );
  }

  static Future<void> onWaiting(func, timer) {
    var duration = Duration(milliseconds: timer);
    return Future.delayed(duration, func);
  }

  static onRadius(int type, double val) {
    if (type == 1) {
      return BorderRadius.all(Radius.circular(val));
    } else if (type == 2) {
      return BorderRadius.only(
        bottomLeft: Radius.circular(val),
        bottomRight: Radius.circular(val),
      );
    } else {
      return BorderRadius.only(
        topLeft: Radius.circular(val),
        topRight: Radius.circular(val),
      );
    }
  }

  static Future<void> isPermissionPermanentDenied(context, label,isBahasaIndo,isDark) async {
    return showAlert(
      context,
      AlertGlobal(
        enableBack:true,
        isDark: isDark,
        isBahasaIndo: isBahasaIndo,
        onCatch: openAppSettings,
        labelCatch: isBahasaIndo ? LabelsID.label_btn_open_setting : LabelsEN.label_btn_open_setting,
        desc: label,
      )
    );
  }

  static Future<dynamic> onGetGallery(context,isBahasaIndo,isDark) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      if (await Permission.photos.request().isGranted) {
        try {
          XFile? image = await ImagePicker().pickImage(
            source: ImageSource.gallery,
            maxWidth: 1000,
            maxHeight: 1000,
            imageQuality: 50,
          );
          return image;
        } on PlatformException catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
      else if (await Permission.photos.request().isPermanentlyDenied) {
       log("masuk sini");
        return;
      }
    }
    else {
      if (await Permission.storage.request().isGranted) {
        try {
          XFile? image = await ImagePicker().pickImage(
            source: ImageSource.gallery,
            maxWidth: 1000,
            maxHeight: 1000,
            imageQuality: 50,
          );
          return image;
        } on PlatformException catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        // await isPermissionPermanentDenied(context, Labels.errorPermission);
        openAppSettings();
        return;
      }
    }
  }

  static Future<dynamic> onGetCamera(context,isBahasaIndo,isDark) async {
    if (await Permission.camera.request().isGranted) {
      try {
        XFile? image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxWidth: 1000,
          maxHeight: 1000,
          imageQuality: 50,
        );
        return image;
      } on PlatformException catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    else if (await Permission.camera.request().isPermanentlyDenied) {
      await isPermissionPermanentDenied(context, isBahasaIndo ? LabelsID.errorPermission :LabelsID.errorPermission , isBahasaIndo,isDark);
      return;
    }
  }

  static onSpaceBar(context) {
    var mediaPadding = MediaQuery.of(context).padding;
    var spaceBar = Platform.isIOS
        ? mediaPadding.top
        : mediaPadding.top + mediaPadding.bottom;
    return spaceBar;
  }

  static font2(double size, color, weight) {
    return GoogleFonts.montserrat(
      fontSize: size.toDouble(),
      color: color ?? black,
      fontWeight: weight ?? FontWeight.w500,
    );
  }

  static styleInputSelected() {
    return font1(15.0, black, FontWeight.w500);
  }

  static styleInput() {
    return font1(14.0, black, FontWeight.w400);
  }

  static Size getBoxSize(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    return box.size;
  }

  static styleInputDark() {
    return font1(14.0, white, FontWeight.w400);
  }

  static styleDisable() {
    return font1(15.0, black.withOpacity(0.7), FontWeight.w400);
  }

  static styleHint() {
    return font1(14.0, black.withOpacity(0.4), FontWeight.w400);
  }

  static styleHintDark() {
    return font1(14.0, gray.withOpacity(0.4), FontWeight.w400);
  }

  static errorStyle() {
    return font1(11.0, Red, FontWeight.w400);
  }

  static stringValidate(value) {
    if (value != null) {
      var stringValue = value.toString();
      var trimValue = stringValue.trim();
      if (trimValue != "" && trimValue != "-") {
        return trimValue;
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  static numberValidate(value) {
    if (value != null) {
      if (value is int) {
        return value;
      } else {
        var cleanedValue = value.replaceAll(RegExp(r'[^0-9]'), '');
        if (cleanedValue != "") {
          var isNumeric = int.tryParse(cleanedValue);
          if (isNumeric is int) {
            return isNumeric;
          } else {
            return 0;
          }
        } else {
          return 0;
        }
      }
    } else {
      return 0;
    }
  }

  static stringEmailValidate(value) {
    if (value != null) {
      var stringValue = value.toString();
      var trimValue = stringValue.trim();
      if (trimValue != "" && trimValue != "-" && trimValue.contains('@')) {
        return trimValue;
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  static stringPhoneNumberValidate(value) {
    if (value != null) {
      var stringValue = value.toString();
      var trimValue = stringValue.trim();
      if (trimValue != "" && trimValue != "-" && trimValue.length > 10) {
        return trimValue;
      } else {
        return "";
      }
    } else {
      return "";
    }
  }
}