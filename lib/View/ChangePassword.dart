import 'package:flutter/material.dart';
import 'package:flutter_skripsi/ViewModel/LoginViewModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;

  ChangePasswordScreen({required this.email});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscuretext = true;
  bool _obscuretext1 = true;
  bool _obscuretext2 = true;
  late LoginViewModel viewModel;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel = LoginViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ubah Password',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 400,
                height: 80,
                child: TextField(
                  controller: _oldPasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password Lama',
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
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 400,
                height: 80,
                child: TextField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password Baru',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscuretext1 = !_obscuretext1;
                        });
                      },
                      icon: Icon(
                        _obscuretext1 ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: _obscuretext1,
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 400,
                height: 80,
                child: TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Konfirmasi Password Baru',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscuretext2 = !_obscuretext2;
                        });
                      },
                      icon: Icon(
                        _obscuretext2 ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: _obscuretext2,
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                height: 80,
                width: 400,
                child: ElevatedButton(
                  onPressed: () async {
                    String oldPassword = _oldPasswordController.text;
                    String newPassword = _newPasswordController.text;
                    String confirmPassword = _confirmPasswordController.text;

                    if (newPassword == confirmPassword) {
                      await viewModel.changePass(
                          context, widget.email, newPassword, oldPassword);
                    } else {
                      Fluttertoast.showToast(
                        msg: "Password Baru dan Konfirmasi Password harus sama",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                      );
                    }
                  },
                  child: Text('Ubah Password',
                      style: TextStyle(color: Colors.white, fontSize: 30)),
                ),
              )
            ],
          ))),
    );
  }
}
