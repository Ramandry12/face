
import 'dart:convert';

import 'package:face_recog_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateManager{
  final String IS_LOGIN = 'IS_LOGIN';
  final String IS_BAHASA = 'IS_BAHASA';
  final String IS_DARK = 'IS_DARK';
  // Properti User Model
  final String ID_USER = 'ID_USER';
  final String USERNAME = 'USERNAME';
  final String NAME = 'NAME';
  final String PHONE = 'PHONE';
  final String EMAIL = 'EMAIL';
  final String ID_FR = 'ID_FR';
  final String IS_ACTIVE = 'IS_ACTIVE';
  final String IS_SUPERUSER = 'IS_SUPERUSER';
  final String TOKEN = 'TOKEN';
  final String RECENT_SEARCH = 'RECENT_SEARCH';


  Future<void> setBahasa(bool isBahasaIndo) async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    prefs.setBool(IS_BAHASA, isBahasaIndo);
  }
  Future<void> setToken(String token) async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    prefs.setString(TOKEN, token);
  }
  Future<void> setRecentSearch(List<dynamic> data) async{
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    prefs.setString(RECENT_SEARCH, jsonEncode(data));
  }
  Future<void> setLoginSession(bool isLogin,UserModel userModel) async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    prefs.setBool(IS_LOGIN, isLogin);
    prefs.setInt(ID_USER, userModel.id);
    prefs.setString(USERNAME, userModel.username);
    prefs.setString(NAME, userModel.name);
    prefs.setString(PHONE, userModel.phone);
    prefs.setString(EMAIL, userModel.email);
    prefs.setString(ID_FR, userModel.id_fr);
    prefs.setBool(IS_ACTIVE, userModel.is_active);
    prefs.setBool(IS_SUPERUSER, userModel.is_superuser);
  }
  Future<void> setDarkMode(bool isDark) async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    prefs.setBool(IS_DARK, isDark);
  }
  Future<void> setLogoutSession() async{
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    await prefs.clear();
  }

}