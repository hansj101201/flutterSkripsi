import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/ForgotPassword/EmailForget.dart';
import 'package:flutter_skripsi/View/Login/Login.dart';
import 'package:flutter_skripsi/ViewModel/LocalAuth.dart';
import 'package:flutter_skripsi/ViewModel/LoginViewModel.dart';
import 'package:flutter_skripsi/ViewModel/SharedPref.dart';
import 'package:flutter_skripsi/View/BottomNav/NavigationBar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _obscuretext = true;
  late TextEditingController _passwordController;
  final LoginViewModel loginViewModel = LoginViewModel();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 400,
                height: 80,
                child: TextFormField(
                  readOnly: true,
                  initialValue: widget.salesmanData['ID_SALES'],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ID User',
                  ),
                  style: TextStyle(fontSize: 30),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 400,
                height: 80,
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscuretext = !_obscuretext;
                        });
                      },
                      icon: Icon(
                        _obscuretext ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: _obscuretext,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 30),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width :300,
                    height: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        // Perform login action
                        var username = widget.salesmanData['ID_SALES'];
                        var password = _passwordController.text.toString();

                        print("Username $username");
                        print("Password $password");
                        loginViewModel.login(context, username, password);
                      },
                      child: Text('Login', style: TextStyle(fontSize: 30),),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        bool fingerprintLoginEnabled =
                        await checkFingerprintLoginStatus();

                        if (fingerprintLoginEnabled) {
                          bool auth = await LocalAuth.authentication();
                          print("can authenticate $auth");
                          if (auth) {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isLoggedIn', true);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => bottomnav(
                                      salesmanData: widget.salesmanData)),
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
                      child: Icon(Icons.fingerprint),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => emailForget()),
                  );
                },
                child: Text(
                  "Lupa Password",
                  style: TextStyle(color: Color(0xff0029FF), fontSize: 30),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 60,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text('Login Dengan Akun Lain',style: TextStyle(fontSize: 20)),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
