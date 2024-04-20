import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/Map.dart';
import 'package:flutter_skripsi/ViewModel/ViewModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomerView extends StatefulWidget {
  final ViewModel viewModel;
  final Map<String, dynamic> salesmanData;

  CustomerView({required this.viewModel, required this.salesmanData});

  @override
  _CustomerViewState createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  DateTime? _selectedDate;
  String? selectedValue;
  String? selectedGudangNama;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stok Kanvas'),
      ),
      body: FutureBuilder(
        future: widget.viewModel.getCustomer(widget.salesmanData['ID_SALES']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(children: [
              SizedBox(
                height: 20,
              ),
              // Tambahkan widget TextField dengan dropdown untuk daftar gudang di bawah TextFormField
              SizedBox(height: 10.0),
              Expanded(
                  child: ListView.builder(
                itemCount: widget.viewModel.customer.length,
                itemBuilder: (BuildContext context, int index) {
                  final customer = widget.viewModel.customer[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          title:
                              Text('${customer.idCustomer} - ${customer.nama}'),
                          subtitle: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Tambahkan logika untuk menavigasi ke halaman detail di sini
                                },
                                child: Text('Detail'),
                              ),
                              SizedBox(width: 8),
                              // Untuk memberi jarak antara dua tombol
                              ElevatedButton(
                                onPressed: () {
                                  String titik = customer.titikGps;
                                  List<String> koordinat = titik.split(
                                      ','); // Pisahkan string dengan koma
                                  double latitude = double.parse(koordinat[
                                      0]); // Ambil latitude dari index 0
                                  double longitude = double.parse(koordinat[
                                      1]); // Ambil longitude dari index 1
                                  // Tambahkan logika untuk menavigasi ke peta di sini
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MapScreen(
                                        destination:
                                            LatLng(latitude, longitude)),
                                  ));
                                },
                                child: Text('Map'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
            ]);
          }
        },
      ),
    );
  }
}
