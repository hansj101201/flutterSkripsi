import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/Transaksi/PengembalianCanvas.dart';
import 'package:flutter_skripsi/View/Transaksi/PenjualanCanvas.dart';
import 'package:flutter_skripsi/View/Transaksi/PermintaanCanvasView.dart';
import 'package:flutter_skripsi/View/StockCanvasView.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> salesmanData;
  final viewModel;

  Home({required this.salesmanData, required this.viewModel});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          'Home',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              'PT.ABC',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF120DF4),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Depo: ${widget.salesmanData['ID_DEPO']}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF120DF4),
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Halo ${widget.salesmanData['NAMA']} ...',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF120DF4),
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => PermintaanKanvas(
                                      viewModel: widget.viewModel,
                                      salesmanData: widget.salesmanData,
                                    )),
                          );
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/pictures/request.png',
                                width: 200,
                                height: 200,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              'Permintaan Kanvas',
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF120DF4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 100.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => PenjualanView(
                                      viewModel: widget.viewModel,
                                      salesmanData: widget.salesmanData,
                                    )),
                          );
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/pictures/sales.png',
                                width: 200,
                                height: 200,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              'Penjualan Barang',
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF120DF4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => StockCanvasView(
                                      viewModel: widget.viewModel,
                                      salesmanData: widget.salesmanData,
                                    )),
                          );
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/pictures/stock.png',
                                width: 200,
                                height: 200,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              'Pengembalian Barang',
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF120DF4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 100.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => PengembalianCanvasView(
                                      viewModel: widget.viewModel,
                                      salesmanData: widget.salesmanData,
                                    )),
                          );
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/pictures/return.png',
                                width: 200,
                                height: 200,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              'Stok Barang',
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF120DF4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
