import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/Login.dart';
import 'package:flutter_skripsi/View/LoginWithData.dart'; // Import LoginWithData.dart
import 'package:flutter_skripsi/View/NavigationBar.dart';
import 'package:flutter_skripsi/ViewModel/SharedPref.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.requestPermission(); // Request permission to access location
  await checkLoginTimeAndSetLoggedOut();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkIfLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final bool isLoggedIn = snapshot.data ?? false; // Mengambil nilai boolean dari snapshot.data
          print(isLoggedIn);
          return FutureBuilder<Map<String, dynamic>>(
            future: checkSalesmanSharedPreferences(),
            builder: (context, snapshot1) {
              if (snapshot1.connectionState == ConnectionState.done) {
                if (snapshot1.hasData && (snapshot1.data! as Map).isNotEmpty) {
                  print(snapshot1.data);
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: isLoggedIn ? bottomnav(salesmanData: snapshot1.data!) : LoginWithData(salesmanData: snapshot1.data!),
                  );
                } else {
                  // Jika tidak ada data salesman, arahkan ke halaman login
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
        } else {
          // Ketika masih dalam proses pengecekan apakah pengguna sudah login
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
