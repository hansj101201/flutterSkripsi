import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/Home.dart';
import 'package:flutter_skripsi/View/Login.dart';
import 'package:flutter_skripsi/ViewModel/LocalAuth.dart';
import 'package:flutter_skripsi/ViewModel/LoginViewModel.dart';
import 'package:flutter_skripsi/ViewModel/SharedPref.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginWithData extends StatefulWidget {
  final Map<String, dynamic> salesmanData;

  const LoginWithData({
    Key? key,
    required this.salesmanData,
  }) : super(key: key);

  @override
  _LoginWithDataState createState() => _LoginWithDataState();
}

class _LoginWithDataState extends State<LoginWithData> {
  late TextEditingController _passwordController;
  final LoginViewModel loginViewModel = LoginViewModel();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                readOnly: true,
                initialValue: widget.salesmanData['ID_SALES'],
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Perform login action
                  var username = widget.salesmanData['ID_SALES'];
                  var password = _passwordController.text.toString();

                  print("Username $username");
                  print("Password $password");
                  loginViewModel.login(context, username, password);
                },
                child: Text('Login'),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text('Login Dengan Akun Lain'),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool fingerprintLoginEnabled = await checkFingerprintLoginStatus();

                  if (fingerprintLoginEnabled) {
                    bool auth = await LocalAuth.authentication();
                    print("can authenticate $auth");
                    if (auth) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Home(salesmanData:widget.salesmanData)),
                      );
                    }
                  } else {
                    Fluttertoast.showToast(
                      msg: "Fingerprint Login belum diaktifkan",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                    );
                  }

                },
                child: Text('Login dengan Sidik Jari'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
