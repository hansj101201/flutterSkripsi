import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/ChangePassword.dart';
import 'package:flutter_skripsi/ViewModel/LocalAuth.dart';
import 'package:flutter_skripsi/ViewModel/SharedPref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_skripsi/main.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> salesmanData;

  ProfilePage({required this.salesmanData});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool fingerprintLoginEnabled = false;

  @override
  void initState() {
    super.initState();
    checkFingerprintLoginStatus().then((status) {
      setState(() {
        fingerprintLoginEnabled =
            status; // Perbarui nilai fingerprintLoginEnabled berdasarkan status yang diperiksa
      });
    });
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        'isLoggedIn', false); // Ubah nilai isLoggedIn menjadi false
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => MyApp()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        toolbarHeight: 100,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            iconSize: 40, // Adjust the size of the logout icon
            onPressed: () async {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _logout(context);
                        },
                        child: Text("Logout"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey.shade300,
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          Text(
            widget.salesmanData['NAMA'],
            // Replace with variable for user's name
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          SizedBox(height: 20),
          Text(
            widget.salesmanData['ID_SALES'],
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 30,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: ListTile.divideTiles(
                color: Colors.grey.shade300,
                tiles: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    leading: Container(
                      width: 60, // Set a fixed width for the leading widget
                      alignment: Alignment.center,
                      child: Icon(Icons.person, color: Colors.black, size: 40),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      // Add left padding to the title
                      child: Text(
                        'Profile',
                        style: TextStyle(color: Colors.black, fontSize: 30),
                      ),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      // Add left padding to the title
                      child: Icon(Icons.arrow_forward_ios, color: Colors.black),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    leading: Container(
                      width: 60, // Set a fixed width for the leading widget
                      alignment: Alignment.center,
                      child: Icon(Icons.fingerprint,
                          color: Colors.black, size: 40),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      // Add left padding to the title
                      child: Text('Fingerprint Login',
                          style: TextStyle(color: Colors.black, fontSize: 30)),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      // Add left padding to the title
                      child: Switch(
                        value: fingerprintLoginEnabled,
                        onChanged: (value) async {
                          bool auth = await LocalAuth.authentication();
                          print("can authenticate $auth");
                          if (auth) {
                            await changeFingerprintLogin(); // Memanggil fungsi untuk mengubah nilai fingerprintLogin
                            setState(() {
                              fingerprintLoginEnabled =
                                  !fingerprintLoginEnabled; // Mengubah nilai lokal saat ini kebalikannya
                            });
                          }
                        },
                        activeColor: Colors.green, // Ubah warna ketika aktif
                      ),
                    ),
                    onTap: () {
                      // Tambahkan logika jika diperlukan ketika ListTile ditekan
                    },
                  ),
                  Divider(height: 1, color: Colors.grey),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    leading: Container(
                      width: 60, // Set a fixed width for the leading widget
                      alignment: Alignment.center,
                      child: Icon(Icons.lock, color: Colors.black, size: 40),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      // Add left padding to the title
                      child: Text('Ubah Password',
                          style: TextStyle(color: Colors.black, fontSize: 30)),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      // Add left padding to the title
                      child: Icon(Icons.arrow_forward_ios, color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ChangePasswordScreen(email: widget.salesmanData['EMAIL']),)
                      );
                    },
                  ),
                  Divider(height: 1, color: Colors.grey),
                ],
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
