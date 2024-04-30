import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/Laporan/LaporanPenerimaanView.dart';
import 'package:flutter_skripsi/View/Laporan/LaporanPengembalianView.dart';
import 'package:flutter_skripsi/View/Laporan/LaporanPenjualanView.dart';
import 'package:flutter_skripsi/View/Laporan/LaporanPermintaanView.dart';

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
        title: Text(
          'Transaksi Saya',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0),
            Container(
              width: 400,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LaporanPermintaan(viewModel: widget.viewModel, salesmanData: widget.salesmanData,),)
                  );
                },
                child: Text('Permintaan Barang',
                    style: TextStyle(color: Colors.white, fontSize: 30)),
              ),
            ),
            SizedBox(height: 40.0),
            Container(
              width: 400,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LaporanPenerimaan(viewModel: widget.viewModel, salesmanData: widget.salesmanData,),)
                  );
                },
                child: Text('Penerimaan Barang',
                    style: TextStyle(color: Colors.white, fontSize: 30)),
              ),
            ),
            SizedBox(height: 40.0),
            Container(
              width: 400,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LaporanPenjualan(viewModel: widget.viewModel, salesmanData: widget.salesmanData,),)
                  );
                },
                child: Text('Penjualan Barang',
                    style: TextStyle(color: Colors.white, fontSize: 30)),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: 400,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LaporanPengembalian(viewModel: widget.viewModel, salesmanData: widget.salesmanData,),)
                  );
                },
                child: Text('Pengembalian Barang',
                    style: TextStyle(color: Colors.white, fontSize: 30)),
              ),
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
