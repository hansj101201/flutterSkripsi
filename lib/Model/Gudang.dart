import 'package:flutter/foundation.dart';

class Gudang {
  final String idGudang;
  final String nama;
  final String idDepo;
  final int active;

  Gudang({
    required this.idGudang,
    required this.nama,
    required this.idDepo,
    required this.active,
  });

  factory Gudang.fromJson(Map<String, dynamic> json) {
    return Gudang(
      idGudang: json['ID_GUDANG'],
      nama: json['NAMA'],
      idDepo: json['ID_DEPO'],
      active: json['ACTIVE'],
    );
  }
}
