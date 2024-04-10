// import 'dart:convert';
// import 'package:flutter_skripsi/Model/Customer.dart';
// import 'package:flutter_skripsi/Model/Stock.dart';
// import 'package:http/http.dart' as http;
//
// class CustomerViewModel {
//   List<Customer> _customer = [];
//
//   List<Customer> get barangs => _customer;
//
//   Future<void> checkStockSalesFromApi(String idGudang) async {
//     final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/stock/getStockSales/?ID_GUDANG=$idGudang'));
//
//     if (response.statusCode == 200) {
//       // Handle the response data here, for example:
//       print(response.body);
//       final List<dynamic> data = jsonDecode(response.body);
//       _customer =  data.map((item) => Customer.fromJson(item)).toList();
//       print(_customer);
//     } else {
//       throw Exception('Failed to load stock data from API');
//     }
//   }
//
// }
