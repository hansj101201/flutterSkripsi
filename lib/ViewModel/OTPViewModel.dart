import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/ForgotPassword/ResetPassword.dart';
import 'package:flutter_skripsi/ViewModel/LoginViewModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class OTPViewModel extends ChangeNotifier {
  late int _otp;
  late LoginViewModel _loginViewModel;

  int get otp => _otp;

  OTPViewModel(){
    _loginViewModel = LoginViewModel();
  }

  void checkOtpPass (String otp,String otpController, String email, BuildContext context){
    if (otp == otpController) {
      print("OTP SAMA");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => resetPassword(email: email)),
      );

    } else {
      Fluttertoast.showToast(
        msg: "Invalid OTP",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
      print("Invalid OTP");
    }
  }

  Future<void> verifyOTPPass(String otp,String otpController, String email, int Time, BuildContext context) async {
    int waktu=DateTime.now().minute;

    if(waktu>55){
      if(waktu<=60||waktu<Time%60){
        checkOtpPass(otp, otpController,email, context);
      }
    }else if (waktu<Time){
      checkOtpPass(otp, otpController,email, context);
    }else{
      Fluttertoast.showToast(
        msg: "OTP Expired",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    }
  }

  void sendOTP(String emailuser,int OTP) async {
    _otp=OTP.toInt();
    final smtpServer = gmail("hansjerremy57@gmail.com", "sigi vbqw cbqy whpd");
    final message = Message()
      ..from = Address("hansjerremy57@gmail.com", "Hans")
      ..recipients.add(emailuser)
      ..subject = "OTP"
      ..text = "OTP anda $_otp";
    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      print(e.message);
    }
  }
}