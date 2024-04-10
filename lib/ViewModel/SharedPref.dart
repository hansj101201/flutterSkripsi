import 'dart:convert';
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

Future<void> removeSalesmanSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('salesman');
}

// Fungsi untuk menghapus data 'loginTime' dari SharedPreferences
Future<void> removeLoginTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('loginTime');
}

Future<void> checkLoginTimeAndRemove() async {
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
      await removeSalesmanSharedPreferences();
      await removeLoginTime();
    }
  }
}