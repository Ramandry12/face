import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:face_recog_flutter/main.dart';
import 'coordinates_translator.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(
    this.faces,
    this.imageSize,
    this.rotation,
    this.namePerson,
    this.cameraLensDirection,
  );

  final List<Face> faces;
  final Size imageSize;
  final String namePerson;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.red;
    final Paint paint2 = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 3.0
      ..color = Colors.black;

    for (final Face face in faces) {
      final left = translateX(
        face.boundingBox.left,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final top = translateY(
        face.boundingBox.top,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final right = translateX(
        face.boundingBox.right,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final bottom = translateY(
        face.boundingBox.bottom,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );

      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint1,
      );

      // Add text on the right top outside the rectangle
      //final String text = 'name';
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: namePerson,
          style: Helpers.font1(25.0, black, FontWeight.w400),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );

      final double textX =
          right + 10.0; // Adjust the distance from the right edge
      final double textY = top -
          textPainter.height -
          10.0; // Adjust the distance from the top edge

      textPainter.paint(
        canvas,
        Offset(textX, textY),
      );
      void paintContour(FaceContourType type) {
        final contour = face.contours[type];
        if (contour?.points != null) {
          for (final Point point in contour!.points) {
            canvas.drawCircle(
                Offset(
                  translateX(
                    point.x.toDouble(),
                    size,
                    imageSize,
                    rotation,
                    cameraLensDirection,
                  ),
                  translateY(
                    point.y.toDouble(),
                    size,
                    imageSize,
                    rotation,
                    cameraLensDirection,
                  ),
                ),
                1,
                paint1);
          }
        }
      }

      // void paintLandmark(FaceLandmarkType type) {
      //   final landmark = face.landmarks[type];
      //   if (landmark?.position != null) {
      //     canvas.drawCircle(
      //         Offset(
      //           translateX(
      //             landmark!.position.x.toDouble(),
      //             size,
      //             imageSize,
      //             rotation,
      //             cameraLensDirection,
      //           ),
      //           translateY(
      //             landmark.position.y.toDouble(),
      //             size,
      //             imageSize,
      //             rotation,
      //             cameraLensDirection,
      //           ),
      //         ),
      //         2,
      //         paint2);
      //   }
      // }

      // for (final type in FaceContourType.values) {
      //   paintContour(type);
      // }

      // for (final type in FaceLandmarkType.values) {
      //   paintLandmark(type);
      // }
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}
