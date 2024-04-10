// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_skripsi/Model/Gudang.dart';
//
// class GudangViewModel {
//   List<Gudang> _gudangs = [];
//
//   List<Gudang> get gudangs => _gudangs;
//
//
//   Future<void> getListGudang(String idDepo) async {
//     final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/gudang/getListGudang/?ID_DEPO=$idDepo'));
//
//     if (response.statusCode == 200) {
//       // Handle the response data here, for example:
//       print(response.body);
//       final List<dynamic> data = jsonDecode(response.body);
//       _gudangs =  data.map((item) => Gudang.fromJson(item)).toList();
//       print(_gudangs);
//     } else {
//       throw Exception('Failed to load stock data from API');
//     }
//   }
// }
