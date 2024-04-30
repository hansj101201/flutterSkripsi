import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/BottomNav/Home.dart';
import 'package:flutter_skripsi/ViewModel/LocalAuth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getIdSalesFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? salesmanJson = prefs.getString('salesman');
  if (salesmanJson != null) {
    Map<String, dynamic> salesmanMap = jsonDecode(salesmanJson);
    return salesmanMap['ID_SALES'];
  }
  return null;
}

Future<String?> getLoginTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('loginTime');
}

Future<Map<String, dynamic>> checkSalesmanSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? salesmanJson = prefs.getString('salesman');
  if (salesmanJson != null) {
    Map<String, dynamic> salesmanData = jsonDecode(salesmanJson);
    return salesmanData;
  } else {
    return {}; // Kembalikan map kosong jika data salesman tidak tersedia
  }
}

Future<void> checkLoginTimeAndSetLoggedOut() async {
  String? loginTime = await getLoginTime();
  if (loginTime != null) {
    DateTime previousLogin = DateTime.parse(loginTime);
    DateTime now = DateTime.now();
    print("login time" + loginTime);
    print("previous login" + previousLogin.toString());
    print ("now" + now.toString());
    // Bandingkan apakah tanggal login sama dengan hari ini
    if (previousLogin.year != now.year ||
        previousLogin.month != now.month ||
        previousLogin.day != now.day) {
      // Jika berbeda hari, hapus data dari SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
    }
  }
}

Future<void> changeFingerprintLogin() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool fingerprintLogin = await checkFingerprintLoginStatus(); // Mengecek status saat ini
  await prefs.setBool('fingerprintLogin', !fingerprintLogin); // Mengubah status menjadi kebalikannya
}

Future<bool> checkIfLoggedIn() async {
  // Mendapatkan instance dari Shared Preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Mengecek nilai isLoggedIn di Shared Preferences
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}

Future<bool> checkFingerprintLoginStatus() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('fingerprintLogin') ?? false; // Default value false jika tidak ada data
  } catch (e) {
    print('Error: $e');
    return false;
  }
}