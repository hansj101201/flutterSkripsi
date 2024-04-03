import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/BarangView.dart';
import 'package:flutter_skripsi/View/StockCanvasView.dart';
import 'package:flutter_skripsi/ViewModel/BarangViewModel.dart';
import 'package:flutter_skripsi/ViewModel/SharedPref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  final Map<String, dynamic> salesmanData;

  Home({required this.salesmanData});
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  late String idSales;
  final barangViewModel = BarangViewModel();

  @override
  void initState() {
    super.initState();
    print('Salesman Data: ${widget.salesmanData['ID_SALES']}');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selamat datang di Aplikasi Flutter!',
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk navigasi ke halaman lain di sini
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PermintaanKanvas(viewModel: barangViewModel, salesmanData: widget.salesmanData,)),
                );
              },
              child: Text('Tambah Permintaan Kanvas'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk navigasi ke halaman lain di sini
              },
              child: Text('Show Customer'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk navigasi ke halaman lain di sini
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => StockCanvasView(viewModel: barangViewModel, salesmanData: widget.salesmanData,)),
                );
              },
              child: Text('Lihat Stok Kanvas'),
            ),
          ],
        ),
      ),
    );
  }
}
