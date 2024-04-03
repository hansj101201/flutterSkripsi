import 'package:flutter/foundation.dart';

class Barang {
  final String id;
  final String nama;
  final String idSatuan;
  final double minStok;
  final int active;
  final String namaSatuan;

  Barang({
    required this.id,
    required this.nama,
    required this.idSatuan,
    required this.minStok,
    required this.active,
    required this.namaSatuan,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['ID_BARANG'],
      nama: json['NAMA'],
      idSatuan: json['ID_SATUAN'],
      minStok: double.parse(json['MIN_STOK']),
      active: json['ACTIVE'],
      namaSatuan: json['nama_satuan']
    );
  }
  String operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'nama':
        return nama;
      default:
        throw Exception('Key not found');
    }
  }

}
