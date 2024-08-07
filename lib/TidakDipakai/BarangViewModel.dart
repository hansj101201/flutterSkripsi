// import 'dart:convert';
// import 'package:flutter_skripsi/Model/BarangHargaStock.dart';
// import 'package:flutter_skripsi/Model/Stock.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_skripsi/Model/Barang.dart';
//
// class BarangViewModel {
//   List<Barang> _barangs = [];
//   List<Stock> _stocks = [];
//   List<BarangHargaStock> _barangJualan = [];
//
//   List<Barang> get barangs => _barangs;
//   List<Stock> get stocks => _stocks;
//   List<BarangHargaStock> get barangJualan => _barangJualan;
//
//   Future<void> fetchBarangsFromApi() async {
//     final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/barang/getAllBarang'));
//
//     // print(response.body);
//     if (response.statusCode == 200) {
//       print(response.body);
//       final List<dynamic> data = jsonDecode(response.body);
//       _barangs = data.map((item) => Barang.fromJson(item)).toList();
//       print(_barangs);
//     } else {
//       throw Exception('Failed to load data from API');
//     }
//   }
//
//   Future<void> checkStockSalesFromApi(String idGudang) async {
//     final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/stock/getStockSales/?ID_GUDANG=$idGudang'));
//
//     if (response.statusCode == 200) {
//       // Handle the response data here, for example:
//       print(response.body);
//       final List<dynamic> data = jsonDecode(response.body);
//       _stocks =  data.map((item) => Stock.fromJson(item)).toList();
//       print(_stocks);
//     } else {
//       throw Exception('Failed to load stock data from API');
//     }
//   }
//
//   Future<void> checkStockPenjualan(String idGudang, String date) async {
//     final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/stock/getStockPenjualan/?ID_GUDANG=$idGudang&TANGGAL=$date'));
//
//     if (response.statusCode == 200) {
//       // Handle the response data here, for example:
//       print(response.body);
//       final List<dynamic> data = jsonDecode(response.body);
//       _barangJualan =  data.map((item) => BarangHargaStock.fromJson(item)).toList();
//       print(_barangJualan);
//     } else {
//       throw Exception('Failed to load stock data from API');
//     }
//   }
// }
