import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_skripsi/ViewModel/OTPViewModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class verifyForget extends StatefulWidget {

  final String email;
  const verifyForget({super.key, required this.email});

  @override
  State<verifyForget> createState() => _verifyState();
}

class _verifyState extends State<verifyForget> {

  final _otpController = TextEditingController();
  late OTPViewModel Verifyotp;
  late int otp;
  late int time;

  int generateRandomNumber(int min, int max) {
    Random random = Random();
    int randomNumber = min + random.nextInt(max - min + 1);

    // Check if the generated number is 6 digits long
    while (randomNumber < 100000 || randomNumber > 999999) {
      randomNumber = min + random.nextInt(max - min + 1);
    }
    return randomNumber;
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Verifyotp = OTPViewModel();
    sendOTP();
  }


  int sendOTP() {
    time = DateTime.now().minute+5;
    otp = generateRandomNumber(100000, 999999);
    Verifyotp.sendOTP(widget.email.toString(), otp);
    return time;

  }

  @override
  Widget build(BuildContext context) {
    final viewModel = OTPViewModel();
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
                    "Verifikasi OTP",
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
                      child: TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number, // Hanya menampilkan keyboard angka
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // Hanya menerima angka
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            labelText: 'OTP',
                            hintText: 'Isi Kode OTP'),
                        style: TextStyle(height: 1),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(""),
                      TextButton(
                        onPressed: () {
                          Fluttertoast.showToast(
                            msg: "OTP sudah dikirim",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                          );
                          time = sendOTP();
                        },
                        child: Text(
                          "Resend OTP",
                          style: TextStyle(color: Color(0xff0029FF)),
                        ),
                      )
                    ],
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
                            viewModel.verifyOTPPass(otp.toString(), _otpController.text, widget.email, time, context);
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