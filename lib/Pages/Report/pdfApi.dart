import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:face_recog_flutter/Config/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class pdfApi {
  static Future<File> generateReport(File? image_, dynamic resultDataList, List resultDataNik, bool isBahasaIndo) async {
    final document = pw.Document();
    
    print("resultDataList : $resultDataList");
    print("resultDataNik : $resultDataNik");

    DateTime now = DateTime.now();
    String newDate = DateFormat("HH:mm:ss | dd-MM-yyyy").format(now);
    List spDate = newDate.split("-");
    int monInt = int.parse(spDate[1]);
    String months = MonthsLabel(monInt-1);
    String datesNow = "${spDate[0]}-$months-${spDate[2]}";

    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) => pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Container(
              width: double.maxFinite,
              height: 700,
              padding: const pw.EdgeInsets.all(defaultBlur),
              decoration: const pw.BoxDecoration(
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                border: pw.Border(top: pw.BorderSide(color: PdfColors.grey), bottom: pw.BorderSide(color: PdfColors.grey),
                right: pw.BorderSide(color: PdfColors.grey), left: pw.BorderSide(color: PdfColors.grey))
              ),
              child: pw.Column(
                children: [
                  pw.Center(
                    child: pw.Container(
                      width: double.maxFinite,
                      padding: const pw.EdgeInsets.all(defaultBlur),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("#E9EEF4"),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
                      ),
                      child: pw.Column(
                        children: [
                          pw.Text(
                            isBahasaIndo ? LabelsID.labelFormIdentifyFace.toUpperCase() : LabelsEN.labelFormIdentifyFace.toUpperCase(),
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            )
                          ),
                          pw.Text(
                            isBahasaIndo ? LabelsID.labelFaceMatchingReport : LabelsEN.labelFaceMatchingReport,
                            style: const pw.TextStyle(
                              fontSize: 14
                            )
                          ),
                        ]
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Column(
                        children: <pw.Widget>[
                          if (image_ != null)
                            pw.Image(pw.MemoryImage(image_.readAsBytesSync()),
                            width: 180,
                            height: 200,
                            fit: pw.BoxFit.fitHeight)
                          else 
                            pw.Image(pw.MemoryImage(base64Decode(resultDataNik[0]["foto"])),
                            width: 180,
                            height: 200,
                            fit: pw.BoxFit.fitHeight),
                          pw.SizedBox(height: defaultPadding /2),
                          pw.Center(
                            child: pw.Container(
                              width: 180,
                              decoration: pw.BoxDecoration(
                                color: PdfColor.fromHex("#333333"),
                                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
                              ),
                              padding: const pw.EdgeInsets.all(10.0),
                              child: pw.Text(
                                isBahasaIndo ? LabelsID.labelTargetReport.toUpperCase() : LabelsEN.labelTargetReport.toUpperCase(),
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white
                                ),
                                textAlign: pw.TextAlign.center
                              ),
                            ),
                          ),
                        ]
                      ),
                      pw.SizedBox(
                        width: defaultPadding,
                      ),
                      pw.Column(
                        children: [
                          if (image_ != null)
                            pw.Image(pw.MemoryImage(base64Decode(resultDataList["personDetail"]["imageUrl"])),
                            width: 180,
                            height: 200,
                            fit: pw.BoxFit.fitHeight)
                          else
                            pw.Image(pw.MemoryImage(base64Decode(resultDataNik[0]["foto"])),
                            width: 180,
                            height: 200,
                            fit: pw.BoxFit.fitHeight),
                          pw.SizedBox(height: defaultPadding / 2),
                          pw.Center(
                            child: pw.Container(
                              width: 180,
                              decoration: pw.BoxDecoration(
                                color: PdfColor.fromHex("#FEBD02"),
                                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
                              ),
                              padding: const pw.EdgeInsets.all(10.0),
                              child: pw.Text(
                                isBahasaIndo ? LabelsID.labelCandidateReport.toUpperCase() : LabelsEN.labelCandidateReport.toUpperCase(),
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textAlign: pw.TextAlign.center
                              ),
                            ),
                          ),
                        ]
                      )
                    ]
                  ),
                  pw.SizedBox(height: defaultPadding),
                  pw.Center(
                    child: pw.Container(
                      width: double.maxFinite,
                      padding: const pw.EdgeInsets.all(15.0),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("#E9EEF4"),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
                      ),
                      child: pw.Text(
                        isBahasaIndo ? LabelsID.labelDetailDataReport.toUpperCase() : LabelsEN.labelDetailDataReport.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10.0),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            isBahasaIndo ? LabelsID.labelDetailNik: LabelsEN.labelDetailNik,
                            style: const pw.TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 5.0),
                          pw.Text(
                            isBahasaIndo ? LabelsID.labelDetailNama: LabelsEN.labelDetailNama,
                            style: const pw.TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 5.0),
                          pw.Text(
                            isBahasaIndo ? LabelsID.labelDetailJenisKelamin: LabelsEN.labelDetailJenisKelamin,
                            style: const pw.TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 5.0),
                          pw.Text(
                            isBahasaIndo ? LabelsID.labelDetailTempatLahir: LabelsEN.labelDetailTempatLahir,
                            style: const pw.TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 5.0),
                          pw.Text(
                            isBahasaIndo ? LabelsID.labelDetailTanggalLahir: LabelsEN.labelDetailTanggalLahir,
                            style: const pw.TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 5.0),
                          pw.Text(
                            isBahasaIndo ? LabelsID.labelDetailAgama: LabelsEN.labelDetailAgama,
                            style: const pw.TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 5.0),
                          pw.Text(
                            isBahasaIndo ? LabelsID.labelDetailGolDarah: LabelsEN.labelDetailGolDarah,
                            style: const pw.TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 5.0),
                          pw.Text(
                            isBahasaIndo ? LabelsID.labelDetailKecamatan: LabelsEN.labelDetailKecamatan,
                            style: const pw.TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 5.0),
                          pw.Text(
                            isBahasaIndo ? LabelsID.labelDetailKelurahan: LabelsEN.labelDetailKelurahan,
                            style: const pw.TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 5.0),
                          pw.Text(
                            isBahasaIndo ? LabelsID.labelDetailKewarganegaraan: LabelsEN.labelDetailKewarganegaraan,
                            style: const pw.TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ]
                      ),
                      pw.SizedBox(width: 20.0),
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          if (image_ != null) 
                            pw.Text(
                              resultDataList["personDetail"]["nik"],
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            )
                          else
                            pw.Text(
                              resultDataNik[0]["nik"],
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          pw.SizedBox(height: 5.0),
                          if (image_ != null) 
                            pw.Text(
                              resultDataList["personDetail"]["nama"],
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            )
                          else
                            pw.Text(
                              resultDataNik[0]["nama"],
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          pw.SizedBox(height: 5.0),
                          if (image_ != null) 
                            pw.Text(
                              resultDataList["personDetail"]["jenisKelamin"],
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            )
                          else
                            pw.Text(
                              resultDataNik[0]["jenisKelamin"],
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          pw.SizedBox(height: 5.0),
                          if (image_ != null) 
                            pw.Text(
                              resultDataList["personDetail"]["tempatLahir"],
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            )
                          else
                            pw.Text(
                              resultDataNik[0]["tempatLahir"],
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          pw.SizedBox(height: 5.0),
                          if (image_ != null) 
                            pw.Text(
                              resultDataList["personDetail"]["tanggalLahir"],
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            )
                          else
                            pw.Text(
                              resultDataNik[0]["tanggalLahir"],
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          pw.SizedBox(height: 5.0),
                          if (image_ != null) 
                            pw.Text(
                              resultDataList["personDetail"]["agama"] ?? "-",
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            )
                          else
                            pw.Text(
                              resultDataNik[0]["agama"] ?? "-",
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          pw.SizedBox(height: 5.0),
                          if (image_ != null) 
                            pw.Text(
                              resultDataList["personDetail"]["golDarah"] ?? "-",
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            )
                          else
                            pw.Text(
                              resultDataNik[0]["golDarah"] ?? "-",
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          pw.SizedBox(height: 5.0),
                          if (image_ != null) 
                            pw.Text(
                              resultDataList["personDetail"]["kecamatan"] ?? "-",
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            )
                          else
                            pw.Text(
                              resultDataNik[0]["kecamatan"] ?? "-",
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          pw.SizedBox(height: 5.0),
                          if (image_ != null) 
                            pw.Text(
                              resultDataList["personDetail"]["kelurahan"] ?? "-",
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            )
                          else
                            pw.Text(
                              resultDataNik[0]["kelurahan"] ?? "-",
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          pw.SizedBox(height: 5.0),
                          if (image_ != null) 
                            pw.Text(
                              resultDataList["personDetail"]["kewarganegaraan"] ?? "-",
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            )
                          else
                            pw.Text(
                              resultDataNik[0]["kewarganegaraan"] ?? "-",
                              style: const pw.TextStyle(
                                fontSize: 14,
                              ),
                            ),
                        ]
                      ),
                    ]
                  ),
                ]
              ),
            ),
            pw.SizedBox(height: defaultBlur),
            pw.Text(
              datesNow,
              style: const pw.TextStyle(
                fontSize: 14
              ),
            ),
          ]
        ),
      )
    );

    var intRand = Random().nextInt(999); 

    return saveDocument(name: 'report_identify_face_$intRand.pdf', pdf: document);
  }

  static String MonthsLabel(int mon) {

    List<String> months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    var label = months[mon];
    
    return label;
  }
  
  static Future<File> saveDocument({
    required String name, 
    required pw.Document pdf
  }) async {
      final dir = await getTemporaryDirectory();
      final docPath = '${dir.path}/myDocuments';
      final dirPath = await Directory(docPath).create(recursive: true);
      
      final file = File('$docPath/$name');

      final bytes = await pdf.save();

      await file.writeAsBytes(bytes);

      return file;

  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Future<File?> downloadFile(File pdfFile, String name) async {
    try {
      var dir;
      if (Platform.isIOS) {
        dir = await getDownloadsDirectory();
      } else {
        dir = "/storage/emulated/0/Download";
      }

      Uint8List bytes = pdfFile.readAsBytesSync();

      final file = File('$dir/$name');

      /* final res = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: Duration.zero
        ),
      ); */

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(bytes);
      await raf.close();
      
      Helpers.viewToast("Download File Success on Download Folder", 1);

      return file;
    } catch (e) {
      Helpers.viewToast(e.toString(), 1);
      return null;
    }
  }

}