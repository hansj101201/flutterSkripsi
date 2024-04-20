import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/CustomerView.dart';
import 'package:flutter_skripsi/View/Login.dart';
import 'package:flutter_skripsi/View/Map.dart';
import 'package:flutter_skripsi/View/PengembalianCanvas.dart';
import 'package:flutter_skripsi/View/PenjualanCanvas.dart';
import 'package:flutter_skripsi/View/PermintaanCanvasView.dart';
import 'package:flutter_skripsi/View/StockCanvasView.dart';
import 'package:flutter_skripsi/ViewModel/LocalAuth.dart';
import 'package:flutter_skripsi/ViewModel/SharedPref.dart';
import 'package:flutter_skripsi/ViewModel/ViewModel.dart';
import 'package:flutter_skripsi/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> salesmanData;
  final viewModel;

  Home({required this.salesmanData, required this.viewModel});
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  late String idSales;
  // final viewModel = ViewModel();
  // final gudangViewModel = GudangViewModel();

  @override
  void initState() {
    super.initState();
    print('Salesman Data: ${widget.salesmanData['ID_SALES']}');
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Ubah nilai isLoggedIn menjadi false
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => MyApp()),
          (Route<dynamic> route) => false,
    );
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
                  MaterialPageRoute(builder: (context) => PermintaanKanvas(viewModel: widget.viewModel, salesmanData: widget.salesmanData,)),
                );
              },
              child: Text('Tambah Permintaan Kanvas'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk navigasi ke halaman lain di sini
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CustomerView(viewModel: widget.viewModel, salesmanData: widget.salesmanData)),
                );
              },
              child: Text('Show Customer'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PenjualanView(viewModel: widget.viewModel, salesmanData: widget.salesmanData)),
                );
              },
              child: Text('Penjualan'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk navigasi ke halaman lain di sini
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => StockCanvasView(viewModel: widget.viewModel, salesmanData: widget.salesmanData,)),
                );
              },
              child: Text('Lihat Stok Kanvas'),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk navigasi ke halaman lain di sini
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PengembalianCanvasView(viewModel: widget.viewModel, salesmanData: widget.salesmanData,)),
                );
              },
              child: Text('Pengembalian Barang Kanvas'),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                _logout(context);
              },
              child: Text('Logout'),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async {
                bool fingerprintLoginEnabled = await checkFingerprintLoginStatus();

                bool enableFingerprint = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Enable Fingerprint Login'),
                    content: Text(fingerprintLoginEnabled ? 'Nonaktifkan login dengan sidik jari?' : 'Aktifkan login dengan sidik jari?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('Tidak'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Mengubah status fingerprint login dan menyimpannya di SharedPreferences
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('fingerprintLogin', !fingerprintLoginEnabled);
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Ya'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Enable Fingerprint'),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MapScreen(destination: LatLng(-7.305050053256325, 112.78471995245445)),)
                );
              },
              child: Text('Test Google Map'),
            ),
          ],
        ),
      ),
    );
  }
}
