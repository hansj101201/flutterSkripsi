import 'package:flutter/foundation.dart';

class Stock {
  final String id;
  final String nama;
  final String idSatuan;
  final int active;
  final String namaSatuan;
  final double saldo;

  Stock({
    required this.id,
    required this.nama,
    required this.idSatuan,
    required this.active,
    required this.namaSatuan,
    required this.saldo,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
        id: json['ID_BARANG'],
        nama: json['NAMA'],
        idSatuan: json['ID_SATUAN'],
        active: json['ACTIVE'],
        namaSatuan: json['nama_satuan'],
        saldo: double.parse(json['saldo']),
    );
  }

}
