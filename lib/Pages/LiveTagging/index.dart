import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:face_recog_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';
import 'painters/face_detector_painter.dart';
import './helpers/detector_views.dart';

class LiveTaggingScreen extends StatefulWidget {
  const LiveTaggingScreen({super.key});

  @override
  State<LiveTaggingScreen> createState() => _LiveTaggingScreenState();
}

class _LiveTaggingScreenState extends State<LiveTaggingScreen> {
  var keyHeadView = GlobalKey();

  Size? sizeHeadView;

  bool isDark = false;
  bool isBahasaIndo = true;
  String token = "";
  String type = "";
  bool showSpinner = false;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  String base64Muka ="";
  String namePeople ="Searching...";
  CustomPaint? _customPaint;
  String wordingLiveTagging ="";
  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

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

  void goBack() {
    Navigator.pop(context);
  }

  void setStateManager() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('IS_DARK') ?? false;
      isBahasaIndo = prefs.getBool('IS_BAHASA') ?? true;
      token = prefs.getString('TOKEN') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    var spaceBar = Helpers.onSpaceBar(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height - spaceBar;
    var heightMenu = screenHeight - (sizeHeadView?.height ?? 0);
    var fontColor = isDark ? white : black;
    var containerBottom = isDark ? black2 : white;
    return Background(
        isDarkTheme: isDark,
        child:Stack(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBarText(
                    keyAppBar: keyHeadView,
                    onPressed: goBack,
                    isDark: isDark,
                    label: isBahasaIndo ? LabelsID.labelLiveTagging.toUpperCase() : LabelsEN.labelLiveTagging.toUpperCase()
                ),
                Container(
                  width: screenWidth,
                  height: heightMenu,
                  padding: const EdgeInsets.all(0.0),
                  child: DetectorView(
                      title: 'Face Detector',
                      customPaint: _customPaint,
                      wording: wordingLiveTagging,
                      height: heightMenu,
                      onImage: processImage,
                      initialCameraLensDirection: _cameraLensDirection,
                      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
                    ),
                )
              ],
            )
          ],
        )
    );
  }
  String imageToBase64(Uint8List bytes) {// Replace with the path to your image file
    return base64Encode(bytes);
  }
  List<int> convertBase64ToImage(String base64String) {
    return base64Decode(base64String.split(',').last);
  }
  void processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {

      setState(() {
        base64Muka = faces.isEmpty ? "" : base64Muka;
        wordingLiveTagging = faces.isEmpty ? 'Wajah Tidak Ditemukan' : '${faces.length} Wajah Ditemukan';
      });

      if(faces.isNotEmpty && base64Muka.isEmpty){
        base64Muka = imageToBase64(inputImage.bytes!);
        //apiSearchImage(imageFile);
      }

      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        "Mohammad Rafii B.",
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      log(text);
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;

  }
  void apiSearchImage(File file) async {
    log("path = "+file.path);
    final url = FRServer.hostServer + Endpoint.searchImage;
    FormData body = FormData.fromMap({
      'file': MultipartFile.fromFile(file.path),
      'fetch_limit': 8,
    });
    Api().servicePostImage(url, body, token: token).then((response) async {
      log("responseImage = "+response.toString());
      if (response['data']['status'] < 300) {
        setState(() {
          namePeople = response['data']['value'][0]["personDetail"]["nama"];
        });
      }
      else {
        Helpers.viewToast(response['data']['message'].toString(), 3);
      }
    }).catchError((e) {
      Helpers.viewToast(e.toString(), 3);
    });
  }
}
