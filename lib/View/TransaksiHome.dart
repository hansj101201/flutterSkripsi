import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/LaporanPenerimaanView.dart';
import 'package:flutter_skripsi/View/LaporanPengembalianView.dart';
import 'package:flutter_skripsi/View/LaporanPermintaanView.dart';

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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LaporanPermintaan(viewModel: widget.viewModel, salesmanData: widget.salesmanData,),)
                );
              },
              child: Text('Permintaan Barang'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LaporanPenerimaan(viewModel: widget.viewModel, salesmanData: widget.salesmanData,),)
                );
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LaporanPengembalian(viewModel: widget.viewModel, salesmanData: widget.salesmanData,),)
                );
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
