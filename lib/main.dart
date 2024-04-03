import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/Home.dart';
import 'package:flutter_skripsi/View/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: checkSalesmanSharedPreferences(), // Mengecek SharedPreferences
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && (snapshot.data! as Map).isNotEmpty) {
            // Jika SharedPreferences dengan kunci 'salesman' ditemukan, redirect ke halaman Home
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Home(salesmanData: snapshot.data!),
            );
          } else {
            // Jika tidak ditemukan, tampilkan halaman Login
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Login(),
            );
          }
        } else {
          // Tampilkan loading indicator jika masih dalam proses pengecekan SharedPreferences
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
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
}
