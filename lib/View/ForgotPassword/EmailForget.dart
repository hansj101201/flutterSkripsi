import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/ForgotPassword/VerifyForget.dart';
import 'package:flutter_skripsi/ViewModel/LoginViewModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class emailForget extends StatefulWidget {
  const emailForget({super.key});

  @override
  State<emailForget> createState() => _emailForgetState();
}

class _emailForgetState extends State<emailForget> {
  final _emailController = TextEditingController();
  final LoginViewModel _loginViewModel = LoginViewModel();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lupa Password',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Center(
        // Membuat tampilan berada di tengah secara vertikal
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Isi Email',
                    ),
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 40),
                  Container(
                    height: 60,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_emailController.text.toString() == "") {
                          Fluttertoast.showToast(
                            msg: "Kolom email harus diisi",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                          );
                        } else {
                          // Panggil fungsi checkEmail dari LoginViewModel
                          String? response = await _loginViewModel
                              .checkEmail(_emailController.text.toString());

                          // Handle response sesuai kebutuhan Anda
                          if (response != null) {
                            // Lakukan sesuatu dengan response
                            print("aaaaa" + response);
                            Fluttertoast.showToast(
                              msg: "OTP sudah dikirimkan ke email anda",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                            );
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => verifyForget(
                                      email: _emailController.text.toString())),
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: "Email tidak ditemukan",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                            );
                          }
                        }
                      },
                      child: Text(
                        'Kirim',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
