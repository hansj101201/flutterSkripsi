import 'package:flutter/material.dart';
import 'package:flutter_skripsi/ViewModel/LoginViewModel.dart';

class Login extends StatelessWidget {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginViewModel loginViewModel = LoginViewModel();

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
                controller: _usernameController,
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
                  var username = _usernameController.text.toString();
                  var password = _passwordController.text.toString();

                  print("Username $username");
                  print("Password $password");
                  loginViewModel.login(context,username,password);
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}