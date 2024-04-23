import 'dart:convert';
import 'package:flutter_skripsi/Model/BarangHargaStock.dart';
import 'package:flutter_skripsi/Model/Closing.dart';
import 'package:flutter_skripsi/Model/Customer.dart';
import 'package:flutter_skripsi/Model/Gudang.dart';
import 'package:flutter_skripsi/Model/Stock.dart';
import 'package:flutter_skripsi/Model/laporanPenerimaan.dart';
import 'package:flutter_skripsi/Model/laporanPengembalian.dart';
import 'package:flutter_skripsi/Model/laporanPermintaan.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_skripsi/Model/Barang.dart';

class ViewModel {
  List<Barang> _barangs = [];
  List<Stock> _stocks = [];
  List<BarangHargaStock> _barangJualan = [];
  List<Gudang> _gudangs = [];
  List<Customer> _customer = [];
  List<Closing> _closing = [];
  List<TransaksiPermintaan> _laporanPermintaan = [];
  List<TransaksiPenerimaan> _laporanPenerimaan = [];
  List<TransaksiPengembalian> _laporanPengembalian = [];


  List<Gudang> get gudangs => _gudangs;
  List<Barang> get barangs => _barangs;
  List<Stock> get stocks => _stocks;
  List<BarangHargaStock> get barangJualan => _barangJualan;
  List<Customer> get customer => _customer;
  List<Closing> get closing => _closing;
  List<TransaksiPermintaan> get laporanPermintaan => _laporanPermintaan;
  List<TransaksiPenerimaan> get laporanPenerimaan => _laporanPenerimaan;
  List<TransaksiPengembalian> get laporanPengembalian => _laporanPengembalian;


  Future<void> getListGudang(String idDepo) async {
    final response = await http.get(Uri.parse('http://192.168.1.14:8000/api/gudang/getListGudang/?ID_DEPO=$idDepo'));
    if (response.statusCode == 200) {
      // Handle the response data here, for example:
      print(response.body);
      final List<dynamic> data = jsonDecode(response.body);
      _gudangs =  data.map((item) => Gudang.fromJson(item)).toList();
      print(_gudangs);
    } else {
      throw Exception('Failed to load stock data from API');
    }
  }
  Future<String> getTanggalClosing(String idDepo) async {
    final response = await http.get(Uri.parse('http://192.168.1.14:8000/api/penjualan/getTanggalClosing/?ID_DEPO=$idDepo'));
    if (response.statusCode == 200) {
      // Handle the response data here, for example:
      print(response.body);
      final data = jsonDecode(response.body);
      print(data[0]['TGL_CLOSING']);
      return data[0]['TGL_CLOSING'];

    } else {
      throw Exception('Failed to load stock data from API');
    }
  }

  Future<void> getCustomer(String idSales) async {
    final response = await http.get(Uri.parse('http://192.168.1.14:8000/api/customer/getCustomer/?ID_SALES=$idSales'));
    if (response.statusCode == 200) {
      // Handle the response data here, for example:
      // print(response.body);
      final List<dynamic> data = jsonDecode(response.body);
      _customer =  data.map((item) => Customer.fromJson(item)).toList();
      print(_customer.toString());
    } else {
      throw Exception('Failed to load stock data from API');
    }
  }

  Future<void> fetchBarangsFromApi() async {
    final response = await http.get(Uri.parse('http://192.168.1.14:8000/api/barang/getAllBarang'));
    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = jsonDecode(response.body);
      _barangs = data.map((item) => Barang.fromJson(item)).toList();
      print(_barangs);
    } else {
      throw Exception('Failed to load data from API');
    }
  }



  Future<void> checkStockSalesFromApi(String idGudang) async {
    final response = await http.get(Uri.parse('http://192.168.1.14:8000/api/stock/getStockSales/?ID_GUDANG=$idGudang'));
    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = jsonDecode(response.body);
      _stocks =  data.map((item) => Stock.fromJson(item)).toList();
      print(_stocks);
    } else {
      throw Exception('Failed to load stock data from API');
    }
  }

  Future<void> checkStockPenjualan(String idGudang, String date) async {
    final response = await http.get(Uri.parse('http://192.168.1.14:8000/api/stock/getStockPenjualan/?ID_GUDANG=$idGudang&TANGGAL=$date'));
    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = jsonDecode(response.body);
      _barangJualan =  data.map((item) => BarangHargaStock.fromJson(item)).toList();
      print(_barangJualan);
    } else {
      throw Exception('Failed to load stock data from API');
    }
  }

  Future<void> getLaporanPermintaan(String idSales, String date) async {
    final response = await http.get(Uri.parse('http://192.168.1.14:8000/api/laporanSales/getPermintaan/?ID_SALES=$idSales&TANGGAL=$date'));
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> dataMap = jsonDecode(response.body);
      List<TransaksiPermintaan> transaksis = TransaksiPermintaan.listFromJson(dataMap);
      _laporanPermintaan = transaksis;
      print(_laporanPermintaan);
    } else {
      throw Exception('Failed to load stock data from API');
    }
  }

  Future<void> getLaporanPenerimaan(String idSales, String date) async {
    final response = await http.get(Uri.parse('http://192.168.1.14:8000/api/laporanSales/getPenerimaan/?ID_SALES=$idSales&TANGGAL=$date'));
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> dataMap = jsonDecode(response.body);
      List<TransaksiPenerimaan> transaksis = TransaksiPenerimaan.listFromJson(dataMap);
      _laporanPenerimaan = transaksis;
      print(_laporanPenerimaan);
    } else {
      throw Exception('Failed to load stock data from API');
    }
  }

  Future<void> getLaporanPengembalian(String idSales, String date) async {
    final response = await http.get(Uri.parse('http://192.168.1.14:8000/api/laporanSales/getPengembalian/?ID_SALES=$idSales&TANGGAL=$date'));
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> dataMap = jsonDecode(response.body);
      List<TransaksiPengembalian> transaksis = TransaksiPengembalian.listFromJson(dataMap);
      _laporanPengembalian = transaksis;
      print(_laporanPengembalian);
    } else {
      throw Exception('Failed to load stock data from API');
    }
  }

  Future<PostPengembalianSalesResult> postPengembalianSales(String tanggal, String idSales, String idGudang, String idGudangTujuan, String periode, String idDepo, List<List<dynamic>> data) async {
    final url = Uri.parse(
        'http://192.168.1.14:8000/api/pengembalian/postPengembalian'); // Ganti dengan URL API pengembalian sales Anda
    final response = await http.post(
      url,
      body: jsonEncode({
        'TANGGAL': tanggal,
        'ID_SALES': idSales,
        'ID_GUDANG': idGudang,
        'ID_DEPO': idDepo,
        'PERIODE': periode,
        'ID_GUDANG_TUJUAN': idGudangTujuan,
        'DATA': data,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return PostPengembalianSalesResult(true, responseData);
    } else {
      final responseData = jsonDecode(response.body);
      return PostPengembalianSalesResult(false, responseData);
    }
  }

  Future<PostPermintaanSalesResult> postPermintaanSales(String tanggal, String idSales, String idGudang, String periode, String idDepo, List<List<dynamic>> data) async {
    final url = Uri.parse('http://192.168.1.14:8000/api/permintaan/postPermintaan'); // Ganti dengan URL API permintaan sales Anda
    final response = await http.post(
      url,
      body: jsonEncode({
        'TANGGAL': tanggal,
        'ID_SALES': idSales,
        'ID_GUDANG': idGudang,
        'ID_DEPO': idDepo,
        'PERIODE' : periode,
        'DATA' : data,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print (responseData);
      return PostPermintaanSalesResult(true, responseData);
    } else {
      final responseData = jsonDecode(response.body);
      return PostPermintaanSalesResult(false, responseData);
    }
  }

  Future<PostPenjualanSalesResult> postPenjualan(String tanggal, String idSales, String idGudang, String idCustomer, String periode, String namaCustomer, String idDepo, String jumlah, String discount, String netto, List<List<dynamic>> data) async {
    final url = Uri.parse('http://192.168.1.14:8000/api/penjualan/postPenjualanCanvas'); // Ganti dengan URL API permintaan sales Anda
    final response = await http.post(
      url,
      body: jsonEncode({
        'TANGGAL': tanggal,
        'ID_SALES': idSales,
        'ID_GUDANG': idGudang,
        'ID_DEPO': idDepo,
        'ID_CUSTOMER' : idCustomer,
        'PERIODE' : periode,
        'JUMLAH' : jumlah,
        'DISCOUNT' : discount,
        'NETTO' : netto,
        'KET01' : 'Penjualan Kanvas Ke $idCustomer - $namaCustomer',
        'DATA' : data,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      return PostPenjualanSalesResult(true, responseData);
    } else {
      final responseData = jsonDecode(response.body);
      return PostPenjualanSalesResult(false, responseData);
    }
  }
}

class PostPermintaanSalesResult {
  final bool success;
  final dynamic responseData;

  PostPermintaanSalesResult(this.success, this.responseData);
}

class PostPenjualanSalesResult {
  final bool success;
  final dynamic responseData;

  PostPenjualanSalesResult(this.success, this.responseData);
}

class PostPengembalianSalesResult {
  final bool success;
  final dynamic responseData;

  PostPengembalianSalesResult(this.success, this.responseData);
}