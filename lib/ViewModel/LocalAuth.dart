import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> canAuthenticate() async =>
    await _auth.canCheckBiometrics || await _auth.isDeviceSupported();


  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      return <BiometricType>[];
    }
  }

  static Future<bool> authentication() async {
    try {
      if (!await canAuthenticate()) return false;
      return await _auth.authenticate(
        localizedReason: 'Scan Fingerprint to Authenticate',
      );
    } on PlatformException catch (e) {
      return false;
    }
  }
}