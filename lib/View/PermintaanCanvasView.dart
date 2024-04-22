import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_skripsi/Model/Barang.dart';
import 'package:flutter_skripsi/ViewModel/Format.dart';
import 'package:flutter_skripsi/ViewModel/ViewModel.dart';
import 'package:intl/intl.dart';

class PermintaanKanvas extends StatefulWidget {
  final ViewModel viewModel;
  final Map<String, dynamic> salesmanData;

  PermintaanKanvas({required this.viewModel, required this.salesmanData});

  @override
  _PermintaanKanvasState createState() => _PermintaanKanvasState();
}

class _PermintaanKanvasState extends State<PermintaanKanvas> {
  List<List<dynamic>> data = [];
  List<List<dynamic>> sendData = [];
  late List<TextEditingController> controllers;
  late TextEditingController dateController;
  late List<Barang> displayedBarangs;
  late String searchText;
  Map<String, TextEditingController> barangControllers = {};
  TextEditingController _searchController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime? closingDate;

  @override
  void initState() {
    super.initState();
    data = [];
    controllers = [];
    dateController = TextEditingController();
    dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate);
    displayedBarangs = [];
    searchText = '';
    fetchClosingDate();
    print('Salesman Data: ${widget.salesmanData}');
    _fetchBarangs();
  }

  Future<void> _fetchBarangs() async {
    await widget.viewModel.fetchBarangsFromApi();
    setState(() {
      displayedBarangs = List.from(widget.viewModel.barangs);
      displayedBarangs.forEach((barang) {
        if (!barangControllers.containsKey(barang.nama)) {
          final controller = TextEditingController(text: '0'); // Atur nilai default di sini
          controllers.add(controller);
          barangControllers[barang.nama] = controller;
        }
      });
    });
  }

  void fetchClosingDate() async {
    try {
      // Panggil metode getTanggalClosing dari viewmodel dan tunggu hasilnya
      String closingDate = await widget.viewModel
          .getTanggalClosing(widget.salesmanData['ID_DEPO']);
      // Setelah mendapatkan tanggal penutupan, atur nilai closingDate
      setState(() {
        this.closingDate = DateTime.parse(closingDate);
      });
    } catch (error) {
      print('Error: $error');
      // Tangani kesalahan yang terjadi saat memuat data
    }
  }

  void _searchBarang(String query) {
    setState(() {
      searchText = query;
      if (query.isEmpty) {
        displayedBarangs = widget.viewModel.barangs.toList();
        controllers.forEach((controller) {
          final barangController = barangControllers[controller];
          if (barangController != null && controller.text.isEmpty) {
            controller.text = barangController.text;
          }
        });
        // Hanya menghapus barangControllers jika sudah tidak ada barang yang ditampilkan
        if (displayedBarangs.isEmpty) {
          barangControllers.clear(); // Mengosongkan barangControllers
        }
      } else {
        displayedBarangs = widget.viewModel.barangs
            .where((barang) =>
            barang.nama.toLowerCase().contains(query.toLowerCase()) ||
                barang.id.toLowerCase().contains(query.toLowerCase()))
            .toList();
        displayedBarangs.forEach((barang) {
          if (!barangControllers.containsKey(barang.nama)) {
            final controller = TextEditingController(text: '0');
            controllers.add(controller);
            barangControllers[barang.nama] = controller;
          }
        });
      }
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
        title: Text('Permintaan Kanvas'),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Barang',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear), // Icon silang
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchBarang('');
                    });
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              onChanged: _searchBarang,
            ),
          ),
          Expanded(
            child: closingDate == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                :dateController.text.isEmpty
                ? Center(child: Text('Masukkan Tanggal'))
                : dateTime.isBefore(closingDate!) ||
                        dateTime.isAtSameMomentAs(closingDate!)
                    ? Center(
                        child: Text(
                          'Tidak dapat input penjualan karena sudah closing',
                          style: TextStyle(fontSize: 40),
                        ),
                      )
                    : ListView.builder(
                        itemCount: displayedBarangs.length,
                        itemBuilder: (context, index) {
                          final barang = displayedBarangs[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  title: Text(barang.nama),
                                  subtitle: Text(
                                      'ID: ${barang.id} - Satuan: ${barang.namaSatuan}'),
                                  onTap: () {
                                    // Tambahkan logika untuk menavigasi ke halaman detail barang di sini
                                  },
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  height: 50, // Atur tinggi sesuai kebutuhan
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          final controller =
                                              barangControllers[barang.nama];
                                          if (controller != null) {
                                            final value =
                                                int.tryParse(controller.text) ??
                                                    0;
                                            if (value > 0) {
                                              controller.text =
                                                  (value - 1).toString();
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '-',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          controller:
                                              barangControllers[barang.nama],
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            // Hanya mengizinkan input angka
                                          ],
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            final intValue = int.parse(value);
                                            final formattedValue = formatHarga(intValue);
                                            barangControllers[barang.nama]?.text = formattedValue;
                                          },
                                          onEditingComplete: () {
                                            // Perbarui nilai yang diformat ke dalam controller
                                            final formattedText = barangControllers[barang.nama]?.text.replaceAll(',', '');
                                            final intValue = int.tryParse(formattedText ?? '0') ?? 0;
                                            barangControllers[barang.nama]?.text = formatHarga(intValue);

                                            // Tutup keyboard secara manual
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      GestureDetector(
                                        onTap: () {
                                          final controller =
                                              barangControllers[barang.nama];
                                          if (controller != null) {
                                            final value =
                                                int.tryParse(controller.text) ??
                                                    0;
                                            controller.text =
                                                (value + 1).toString();
                                          }
                                        },
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '+',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
          ),
          ElevatedButton(
            onPressed: () {
              var periode = getPeriode(dateController.text);
              print(periode);
              sendData = [];
              // Tampilkan data yang akan dikirim
              displayedBarangs.forEach((barang) {
                final controller = barangControllers[barang.nama];
                print("test"+controller.toString());
                if (controller != null) {
                  final text = controller.text.replaceAll(RegExp(r'[^0-9]'), ''); // Menghapus karakter non-angka
                  final value = int.tryParse(text) ?? 0;
                  print (value);
                  if (value > 0) {
                    sendData.add([barang.id, barang.nama, value]);
                  }
                }
              });
              print(dateController.text);
              print(sendData);

              // Tampilkan popup konfirmasi
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Data yang akan dikirim:'),
                    content: SizedBox(
                      width: double.maxFinite,
                      height: 300,
                      child: ListView.builder(
                        itemCount: sendData.length,
                        itemBuilder: (context, index) {
                          final item = sendData[index];
                          return ListTile(
                            title: Text(
                                'Barang ID: ${item[0]}, nama: ${item[1]}, value: ${item[2]}'),
                          );
                        },
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          final success = await widget.viewModel
                              .postPermintaanSales(
                                  dateController.text,
                                  widget.salesmanData['ID_SALES'],
                                  widget.salesmanData['ID_GUDANG'],
                                  getPeriode(dateController.text),
                                  widget.salesmanData['ID_DEPO'],
                                  sendData);
                          if (success) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Gagal menyimpan data'),
                              duration: Duration(seconds: 2),
                            ));
                          }
                        },
                        child: Text('Kirim'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Batal
                          Navigator.of(context).pop();
                        },
                        child: Text('Batal'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Show Data'),
          ),
        ],
      ),
    );
  }
}
