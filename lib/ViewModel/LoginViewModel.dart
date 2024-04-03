import 'dart:convert';
import 'package:flutter_skripsi/View/Home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel {
  Future<bool> login(BuildContext context, String userId, String password) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/salesman/login'); // Ganti dengan URL API login Anda
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('salesman', jsonEncode(salesmanDataMap));


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
