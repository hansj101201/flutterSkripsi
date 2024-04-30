import 'dart:convert';
import 'package:flutter_skripsi/View/Login/Login.dart';
import 'package:flutter_skripsi/View/BottomNav/NavigationBar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel {
  Future<bool> login(BuildContext context, String userId, String password) async {
    final url = Uri.parse('http://192.168.1.14:8000/api/salesman/login'); // Ganti dengan URL API login Anda
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedSalesmanDataString = prefs.getString('salesman');
      if (savedSalesmanDataString != null) {
        Map<String, dynamic> savedSalesmanData = jsonDecode(savedSalesmanDataString);

        // Bandingkan data salesman dari response dengan data salesman yang disimpan
        if (salesmanDataMap.toString() == savedSalesmanData.toString()) {
          print('Data salesman sama');
        } else {
          print('Data salesman berbeda');
          await prefs.setBool('fingerprintLogin', false);
        }
      }

      await prefs.setString('salesman', jsonEncode(salesmanDataMap));
      await prefs.setString('loginTime', DateTime.now().toString());
      await prefs.setBool('isLoggedIn', true);

      // Jika login sukses, kembalikan true
      print("Behasil Login");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => bottomnav(salesmanData: salesmanDataMap,)),
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

  Future<String?> checkEmail(String email) async {
    final url = Uri.parse(
        'http://192.168.1.14:8000/api/salesman/cekEmail/?EMAIL=$email');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      return responseBody;
    } else {
      // Handle jika status code bukan 200
      print('Failed to check email. Status code: ${response.statusCode}');

      return null;
    }
  }

  Future<void> changePass(BuildContext context, String email, String password, String passwordLama) async {
    final url = Uri.parse('http://192.168.1.14:8000/api/salesman/changePassword'); // Ganti dengan URL API login Anda
    final response = await http.put(
      url,
      body: jsonEncode({'EMAIL': email, 'PASSWORD': password, 'PASSWORDLAMA': passwordLama}),
      headers: {'Content-Type': 'application/json'},
    );

    print(jsonEncode({'EMAIL': email, 'PASSWORD': password}));

    if (response.statusCode == 200) {
      //
      final responseData = jsonDecode(response.body);
      Fluttertoast.showToast(
        msg: "Berhasil Mengubah Password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
      Navigator.of(context).pop();
    } else {
      // Jika login gagal, kembalikan false
      print("Gagal Login");
      Fluttertoast.showToast(
        msg: "Password lama salah",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    }
  }

  Future<bool> forgetPass(BuildContext context, String email, String password) async {
    final url = Uri.parse('http://192.168.1.14:8000/api/salesman/resetPassword'); // Ganti dengan URL API login Anda
    final response = await http.put(
      url,
      body: jsonEncode({'EMAIL': email, 'PASSWORD': password}),
      headers: {'Content-Type': 'application/json'},
    );

    print(jsonEncode({'EMAIL': email, 'PASSWORD': password}));

    if (response.statusCode == 200) {
      //
      final responseData = jsonDecode(response.body);
      Fluttertoast.showToast(
        msg: "Berhasil Mengubah Password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()),
      );
      return true;
    } else {
      // Jika login gagal, kembalikan false
      print("Gagal Login");
      Fluttertoast.showToast(
        msg: "Gagal Mengubah Password",
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

