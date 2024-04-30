import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_skripsi/ViewModel/LoginViewModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class resetPassword extends StatefulWidget {

  final String email;
  const resetPassword({super.key, required this.email});

  @override
  State<resetPassword> createState() => _verifyState();
}

class _verifyState extends State<resetPassword> {

  bool _obscuretext = true;
  bool _obscuretextConfirm = true;
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = LoginViewModel();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
                  ),
                  Text(
                    "Masukkan Password Baru",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff0000A4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFEBB2), // Set the background color
                      borderRadius: BorderRadius.circular(20.0), // Adjust the value for rounded corners
                    ),
                    width: 238,
                    height: 45,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _passController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none
                          ),
                          labelText: 'Kata Sandi Baru',
                          hintText: '********',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscuretext = !_obscuretext;
                              });
                            },
                            icon: Icon(
                              _obscuretext
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xff6C6C6C),
                            ),
                          ),
                        ),
                        obscureText: _obscuretext,
                        style: TextStyle(height: 1),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFEBB2), // Set the background color
                      borderRadius: BorderRadius.circular(20.0), // Adjust the value for rounded corners
                    ),
                    width: 238,
                    height: 45,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _confirmPassController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none
                          ),
                          labelText: 'Konfirmasi Kata Sandi',
                          hintText: '********',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscuretextConfirm = !_obscuretextConfirm;
                              });
                            },
                            icon: Icon(
                              _obscuretextConfirm
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xff6C6C6C),
                            ),
                          ),
                        ),
                        obscureText: _obscuretextConfirm,
                        style: TextStyle(height: 1),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: SizedBox(
                      width: 144,
                      height: 47,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFF670A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Adjust the value as needed
                          ),
                        ),
                        onPressed: () {
                          if(_passController.text.toString() == _confirmPassController.text.toString()){
                            viewModel.forgetPass(context, widget.email, _passController.text.toString());
                          } else {
                            Fluttertoast.showToast(
                              msg: "Password Tidak Sama ",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                            );
                          }

                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}