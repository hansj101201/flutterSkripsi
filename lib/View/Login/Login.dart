import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/ForgotPassword/EmailForget.dart';
import 'package:flutter_skripsi/ViewModel/LoginViewModel.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscuretext = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late LoginViewModel loginViewModel;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loginViewModel = LoginViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 400,
              height: 80,
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ID User',
                ),
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.left,
                onChanged: (value) {
                  _usernameController.value = TextEditingValue(
                    text: value.toUpperCase(), // Mengubah teks menjadi huruf besar
                    selection: _usernameController.selection, // Menjaga seleksi yang ada
                  );
                },
              ),
            ),
            SizedBox(height: 20),
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
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 400,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  loginViewModel.login(
                    context,
                    _usernameController.text.toString().toLowerCase(),
                    _passwordController.text.toString(),
                  );
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => emailForget()),
                );
              },
              child: Text(
                "Lupa Password",
                style: TextStyle(
                  color: Color(0xff0029FF),
                  fontSize: 30, // Memperbesar ukuran teks
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
