import 'package:flutter/foundation.dart';

class Salesman {
  final String id;
  final String nama;
  final String email;
  final String password;
  final String idGudang;
  final String nomorHp;
  final String idDepo;
  final bool active;
  final DateTime tglEdit;
  final DateTime tglEntry;
  final String userEdit;
  final String userEntry;

  Salesman({
    required this.id,
    required this.nama,
    required this.email,
    required this.password,
    required this.idGudang,
    required this.nomorHp,
    required this.idDepo,
    required this.active,
    required this.tglEdit,
    required this.tglEntry,
    required this.userEdit,
    required this.userEntry,
  });

  factory Salesman.fromJson(Map<String, dynamic> json) {
    return Salesman(
      id: json['ID_SALES'],
      nama: json['NAMA'],
      email: json['EMAIL'],
      password: json['PASSWORD'],
      idGudang: json['ID_GUDANG'],
      nomorHp: json['NOMOR_HP'],
      idDepo: json['ID_DEPO'],
      active: json['ACTIVE'],
      tglEdit: DateTime.parse(json['TGLEDIT']),
      tglEntry: DateTime.parse(json['TGLENTRY']),
      userEdit: json['USEREDIT'],
      userEntry: json['USERENTRY'],
    );
  }
}
