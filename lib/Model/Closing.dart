import 'package:flutter/foundation.dart';

class Closing {
  final String tanggal;

  Closing({
    required this.tanggal,
  });

  factory Closing.fromJson(Map<String, dynamic> json) {
    return Closing(
        tanggal: json['TGL_CLOSING'],
    );
  }

}
