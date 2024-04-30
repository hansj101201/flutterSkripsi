import 'package:flutter/material.dart';
import 'package:flutter_skripsi/ViewModel/ViewModel.dart';

class StockCanvasView extends StatefulWidget {
  final ViewModel viewModel;
  final Map<String, dynamic> salesmanData;

  StockCanvasView({required this.viewModel, required this.salesmanData});

  @override
  _StockCanvasViewState createState() => _StockCanvasViewState();
}

class _StockCanvasViewState extends State<StockCanvasView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icon bawaan tombol kembali
          iconSize: 40, // Atur ukuran ikon tombol kembali di sini
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Stok Gudang Sales',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: FutureBuilder(
        future: widget.viewModel.checkStockSalesFromApi(widget.salesmanData['ID_GUDANG']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: widget.viewModel.stocks.length,
              itemBuilder: (BuildContext context, int index) {
                final stocks = widget.viewModel.stocks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        title: Text(
                          '${stocks.id} - ${stocks.nama}',
                          style: TextStyle(
                              fontSize: 30),
                        ),
                        trailing: Text(
                          'Stok: ${stocks.saldo.toStringAsFixed(0)} ${stocks.namaSatuan}',
                          style: TextStyle(
                              fontSize: 30),
                        ),
                        onTap: () {
                          // Tambahkan logika untuk menavigasi ke halaman detail barang di sini
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
