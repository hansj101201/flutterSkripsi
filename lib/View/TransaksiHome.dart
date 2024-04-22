import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/Map.dart';
import 'package:flutter_skripsi/View/PengembalianCanvas.dart';
import 'package:flutter_skripsi/View/PenjualanCanvas.dart';
import 'package:flutter_skripsi/View/PermintaanCanvasView.dart';
import 'package:flutter_skripsi/View/StockCanvasView.dart';
import 'package:flutter_skripsi/ViewModel/SharedPref.dart';
import 'package:flutter_skripsi/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransaksiHome extends StatefulWidget {
  final Map<String, dynamic> salesmanData;
  final viewModel;

  TransaksiHome({required this.salesmanData, required this.viewModel});

  @override
  _TransaksiHomeState createState() => _TransaksiHomeState();
}

class _TransaksiHomeState extends State<TransaksiHome> {
  late String idSales;

  @override
  void initState() {
    super.initState();
    print('Salesman Data: ${widget.salesmanData['ID_SALES']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Transaksi Saya'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('Permintaan Barang'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('Penerimaan Barang'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('Penjualan Barang'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('Pengembalian Barang'),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
