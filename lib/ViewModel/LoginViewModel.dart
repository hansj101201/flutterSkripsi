import 'dart:convert';
import 'package:flutter_skripsi/View/Home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel {
  Future<bool> login(BuildContext context, String userId, String password) async {
    final url = Uri.parse('http://192.168.1.11:8000/api/salesman/login'); // Ganti dengan URL API login Anda
    final response = await http.post(
      url,
      body: jsonEncode({'ID_SALES': userId, 'PASSWORD': password}),
      headers: {'Content-Type': 'application/json'},
    );

    print(jsonEncode({'ID_SALES': userId, 'PASSWORD': password}));

    if (response.statusCode == 200) {
      //
      final responseData = jsonDecode(response.body);

      Map<String, dynamic> salesmanDataMap = responseData['salesman'][0];
      // Simpan data salesman ke shared_preferences
      DateTime now = DateTime.now();
      // Format tanggal ke dalam format 'yyyy-MM-dd'
      String formattedDate = "${now.year}-${_addZeroPrefix(now.month)}-${_addZeroPrefix(now.day)}";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('salesman', jsonEncode(salesmanDataMap));
      await prefs.setString('loginTime', DateTime.now().toString());
      await prefs.setBool('isLoggedIn', true);

      // Jika login sukses, kembalikan true
      print("Behasil Login");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Home(salesmanData: salesmanDataMap,)),
      );
      return true;
    } else {
      // Jika login gagal, kembalikan false
      print("Gagal Login");
      Fluttertoast.showToast(
        msg: "Invalid User ID / Password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
      return false;
    }
  }
}

String _addZeroPrefix(int number) {
  if (number < 10) {
    return '0$number';
  }
  return '$number';
}