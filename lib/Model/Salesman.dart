import 'package:flutter/foundation.dart';

class Salesman {
  final String id;
  final String nama;
  final String email;
  final String idGudang;
  final String nomorHp;
  final String idDepo;

  Salesman({
    required this.id,
    required this.nama,
    required this.email,
    required this.idGudang,
    required this.nomorHp,
    required this.idDepo,
  });

  factory Salesman.fromJson(Map<String, dynamic> json) {
    return Salesman(
      id: json['ID_SALES'],
      nama: json['NAMA'],
      email: json['EMAIL'],
      idGudang: json['ID_GUDANG'],
      nomorHp: json['NOMOR_HP'],
      idDepo: json['ID_DEPO'],
    );
  }
}
