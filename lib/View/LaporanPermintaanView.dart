import 'package:flutter/material.dart';
import 'package:flutter_skripsi/Model/laporanPermintaan.dart';
import 'package:flutter_skripsi/ViewModel/ViewModel.dart';
import 'package:intl/intl.dart';

class LaporanPermintaan extends StatefulWidget {
  final ViewModel viewModel;
  final Map<String, dynamic> salesmanData;

  LaporanPermintaan({required this.viewModel, required this.salesmanData});

  @override
  _LaporanPermintaanState createState() => _LaporanPermintaanState();
}

class _LaporanPermintaanState extends State<LaporanPermintaan> {
  List<TransaksiPermintaan> data = [];
  late TextEditingController dateController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    data = [];
    dateController = TextEditingController();
    dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate);
    print('Salesman Data: ${widget.salesmanData}');
    _fetchBarangs();
  }

  Future<void> _fetchBarangs() async {
    await widget.viewModel.getLaporanPermintaan(widget.salesmanData['ID_SALES'], dateController.text);
    setState(() {
      data = List.from(widget.viewModel.laporanPermintaan);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        if (_selectedDate == null) {
          dateController.text = 'Pilih Tanggal';
        } else {
          dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate);
        }
        print('Date selected: $_selectedDate');
      });
      _fetchBarangs();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> parts = dateController.text.split('-');

// Membuat objek DateTime dari bagian-bagian tanggal
    DateTime dateTime =
    DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Lihat Data Permintaan Barang'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: SizedBox(
              width: 300,
              height: 80,
              child: GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: dateController,
                    style: TextStyle(fontSize: 30),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                // Pastikan bahwa ListTile hanya dibuat untuk bukti yang unik
                if (index > 0 && data[index].bukti == data[index - 1].bukti) {
                  return SizedBox.shrink(); // Skip creating ListTile for duplicate bukti
                }

                // Buat variabel untuk menyimpan informasi transaksi dengan bukti yang sama
                String buktiSekarang = data[index].bukti;
                List<TransaksiPermintaan> transaksisSama = [];

                // Cari semua transaksi dengan bukti yang sama
                for (int i = index; i < data.length; i++) {
                  if (data[i].bukti == buktiSekarang) {
                    transaksisSama.add(data[i]);
                  } else {
                    break; // Jika bukti berbeda, hentikan pencarian
                  }
                }

                // Ubah daftar transaksi yang sama menjadi satu ListTile
                return Theme(
                  data: Theme.of(context).copyWith(
                    visualDensity: VisualDensity.compact, // Menghapus padding atas pada ListTile
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(top: 16, left: 16),
                    title: Text('Bukti : $buktiSekarang',
                      style: TextStyle(
                      fontSize: 30, // Mengatur ukuran teks menjadi 30
                    ),),
                    subtitle: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 0, bottom: 0),
                      physics: NeverScrollableScrollPhysics(), // Untuk memastikan ListView tidak scroll di dalam ListView
                      children: transaksisSama.map((transaksi) {
                        return ListTile(
                          contentPadding: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 0),
                          horizontalTitleGap: 0, // Menghapus jarak horizontal antara title dan leading/trailing widget
                          minVerticalPadding: 0, // Menghapus jarak vertikal minimum
                          minLeadingWidth: 0, // Menghapus lebar minimum leading widget
                          title: Text(
                            '${transaksi.idBarang} - ${transaksi.nama}',
                            style: TextStyle(
                              fontSize: 30, // Mengatur ukuran teks menjadi 30
                              color: Color(0xFF120DF4), // Mengatur warna teks menjadi 120DF4
                            ),
                          ),
                          trailing: Text(
                            '${transaksi.jumlahItem.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 30, // Mengatur ukuran teks menjadi 30
                              color: Color(0xFF120DF4), // Mengatur warna teks menjadi 120DF4
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );

              },
            ),

          ),
        ],
      ),
    );
  }
}
