import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:face_recog_flutter/Config/index.dart';

class Api {
  Future<dynamic> servicePost(url, body, {String? token}) async {
    log("Url Request = $url");
    var dio = Dio();
    try {
      var response = await dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.json,
          validateStatus: (int? status) {
            return status! >= 200 && status <= 500;
          },
        ),
      );

      var result = {"statusCode": response.statusCode, "data": response.data};
      log("Response = $result");
      return Future.value(result);
    } on DioException catch (e) {
      log("Response err = $e");
      return Future.error(e.message.toString());
    }
  }

  Future<dynamic> servicePostImage(url, body, {String? token}) async {
    log("Url Request = $url");
    var dio = Dio();
    try {
      var response = await dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.json,
          validateStatus: (int? status) {
            return status! >= 200 && status <= 500;
          },
        ),
      );
      var result = {"statusCode": response.statusCode, "data": response.data};
      log("Response = $result");
      return Future.value(result);
    } on DioException catch (e) {
      // throw e.message;
      log("Response err = $e");
      return Future.error(e.message.toString());
    }
  }

  Future<dynamic> servicePut(url, body, {String? token}) async {
    log("Url Request = $url");
    var dio = Dio();
    try {
      var response = await dio.put(
        url,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.json,
          validateStatus: (int? status) {
            return status! >= 200 && status <= 500;
          },
        ),
      );

      var result = {"statusCode": response.statusCode, "data": response.data};
      log("Response = $result");
      return Future.value(result);
    } on DioException catch (e) {
      log("Response err = $e");
      return Future.error(e.message.toString());
    }
  }

  Future<dynamic> serviceGet(url, {String? token}) async {
    log("Url Request = $token");
    var dio = Dio();
    try {
      var response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.json,
          validateStatus: (int? status) {
            return status! >= 200 && status <= 500;
          },
        ),
      );
      var result = {"statusCode": response.statusCode, "data": response.data};
      //log("Response = $result");
      return Future.value(result);
    } on DioException catch (e) {
      // throw e.message;
      log("Response err = $e");
      return Future.error(e.message.toString());
    }
  }
}
