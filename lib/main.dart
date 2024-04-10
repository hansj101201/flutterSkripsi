import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/Home.dart';
import 'package:flutter_skripsi/View/Login.dart';
import 'package:flutter_skripsi/ViewModel/SharedPref.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan bahwa WidgetsFlutterBinding sudah diinisialisasi
  await checkLoginTimeAndRemove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: checkSalesmanSharedPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print(snapshot);
          if (snapshot.hasData && (snapshot.data! as Map).isNotEmpty) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Home(salesmanData: snapshot.data!),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Login(),
            );
          }
        } else {
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
}
