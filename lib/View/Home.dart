import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/PengembalianCanvas.dart';
import 'package:flutter_skripsi/View/PenjualanCanvas.dart';
import 'package:flutter_skripsi/View/PermintaanCanvasView.dart';
import 'package:flutter_skripsi/View/StockCanvasView.dart';
import 'package:flutter_skripsi/ViewModel/ViewModel.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> salesmanData;

  Home({required this.salesmanData});
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  late String idSales;
  final viewModel = ViewModel();
  // final gudangViewModel = GudangViewModel();

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
                  MaterialPageRoute(builder: (context) => PermintaanKanvas(viewModel: viewModel, salesmanData: widget.salesmanData,)),
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
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PenjualanView(viewModel: viewModel, salesmanData: widget.salesmanData)),
                );
              },
              child: Text('Penjualan'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk navigasi ke halaman lain di sini
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => StockCanvasView(viewModel: viewModel, salesmanData: widget.salesmanData,)),
                );
              },
              child: Text('Lihat Stok Kanvas'),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk navigasi ke halaman lain di sini
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PengembalianCanvasView(viewModel: viewModel, salesmanData: widget.salesmanData,)),
                );
              },
              child: Text('Pengembalian Barang Kanvas'),
            ),
          ],
        ),
      ),
    );
  }
}
