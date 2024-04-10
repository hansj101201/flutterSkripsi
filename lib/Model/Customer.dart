import 'package:flutter/material.dart';

class Customer {
  final String id;
  final String idCustomer;
  final String nama;
  final String alamat;
  final String kota;
  final String kodepos;
  final String telepon;
  final String pic;
  final String nomorHp;
  final String alamatKirim;
  final String kotaKirim;
  final String kodeposKirim;
  final String teleponKirim;
  final String picKirim;
  final String nomorHpKirim;
  final String idSales;
  final String titikGps;

  Customer({
    required this.id,
    required this.idCustomer,
    required this.nama,
    required this.alamat,
    required this.kota,
    required this.kodepos,
    required this.telepon,
    required this.pic,
    required this.nomorHp,
    required this.alamatKirim,
    required this.kotaKirim,
    required this.kodeposKirim,
    required this.teleponKirim,
    required this.picKirim,
    required this.nomorHpKirim,
    required this.idSales,
    required this.titikGps,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['ID'] ?? '',
      idCustomer: json['ID_CUSTOMER'] ?? '',
      nama: json['NAMA'] ?? '',
      alamat: json['ALAMAT'] ?? '',
      kota: json['KOTA'] ?? '',
      kodepos: json['KODEPOS'] ?? '',
      telepon: json['TELEPON'] ?? '',
      pic: json['PIC'] ?? '',
      nomorHp: json['NOMOR_HP'] ?? '',
      alamatKirim: json['ALAMAT_KIRIM'] ?? '',
      kotaKirim: json['KOTA_KIRIM'] ?? '',
      kodeposKirim: json['KODEPOS_KIRIM'] ?? '',
      teleponKirim: json['TELEPON_KIRIM'] ?? '',
      picKirim: json['PIC_KIRIM'] ?? '',
      nomorHpKirim: json['NOMOR_HP_KIRIM'] ?? '',
      idSales: json['ID_SALES'] ?? '',
      titikGps: json['TITIK_GPS'] ?? '',
    );
  }
}
