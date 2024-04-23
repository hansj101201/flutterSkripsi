import 'package:flutter/material.dart';
import 'package:flutter_skripsi/Model/Gudang.dart';
import 'package:flutter_skripsi/View/BuktiView.dart';
import 'package:flutter_skripsi/ViewModel/Format.dart';
import 'package:flutter_skripsi/ViewModel/ViewModel.dart';
import 'package:intl/intl.dart';

class PengembalianCanvasView extends StatefulWidget {
  final ViewModel viewModel;
  final Map<String, dynamic> salesmanData;

  PengembalianCanvasView({required this.viewModel, required this.salesmanData});

  @override
  _PengembalianCanvasViewState createState() => _PengembalianCanvasViewState();
}

class _PengembalianCanvasViewState extends State<PengembalianCanvasView> {
  late TextEditingController dateController;
  late TextEditingController gudangController;
  List<List<dynamic>> sendData = [];
  DateTime _selectedDate = DateTime.now();
  DateTime? closingDate;
  String? selectedValue;
  String? selectedGudangNama;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate);
    gudangController = TextEditingController(text: 'Pilih Gudang Tujuan');
    fetchClosingDate();
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

  void updateSelectedGudang(String? newValue) {
    selectedGudangNama = newValue ?? 'Pilih Gudang';
    gudangController.text = selectedGudangNama!;
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
          dateController.text = dateController.text =
              DateFormat('dd-MM-yyyy').format(_selectedDate);
        }
        print('Date selected: $_selectedDate');
        // Tambahkan logika untuk menggunakan tanggal yang dipilih
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Closing Date" + closingDate.toString());
    List<String> parts = dateController.text.split('-');

// Membuat objek DateTime dari bagian-bagian tanggal
    DateTime dateTime =
        DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));

    print("${closingDate.toString()} ${dateTime.toString()}");

    return Scaffold(
        appBar: AppBar(
          title: Text('Pengembalian'),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          // Tambahkan widget TextField dengan dropdown untuk daftar gudang di bawah TextFormField
          SizedBox(height: 10.0),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: TextField(
              readOnly: true,
              controller: gudangController,
              style: TextStyle(fontSize: 30),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.arrow_drop_down), // Atur padding konten
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text('Pilih Gudang'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: FutureBuilder(
                            future: widget.viewModel
                                .getListGudang(widget.salesmanData['ID_DEPO']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                List<Gudang>? gudangs =
                                    widget.viewModel.gudangs;
                                if (gudangs == null) {
                                  return Center(
                                      child: Text('No data available'));
                                }
                                return DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedValue,
                                  onChanged: (String? newValue) {
                                    selectedValue =
                                        newValue ?? ''; // Update selectedValue
                                    // Close the dialog after selection
                                    Navigator.pop(context);
                                    updateSelectedGudang(gudangs
                                        .firstWhere(
                                          (gudang) =>
                                              gudang.idGudang.toString() ==
                                              selectedValue,
                                        )
                                        ?.nama);
                                    print(selectedValue);
                                  },
                                  items: gudangs.map((item) {
                                    print(item);
                                    return DropdownMenuItem<String>(
                                      value: item.idGudang.toString(),
                                      child: Container(
                                        width: double.maxFinite,
                                        padding: EdgeInsets.zero,
                                        child: ListTile(
                                          title: Text(
                                              '${item.idGudang} - ${item.nama}'),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                        ));
                  },
                );
              },
            ),
          ),
          SizedBox(height: 10.0),

          Expanded(
              child: closingDate == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : dateController.text.isEmpty
                      ? Center(child: Text('Masukkan Tanggal'))
                      : dateTime.isBefore(closingDate!) ||
                              dateTime.isAtSameMomentAs(closingDate!)
                          ? Center(
                              child: Text(
                                'Tidak dapat input penjualan karena sudah closing',
                                style: TextStyle(fontSize: 40),
                              ),
                            )
                          : Column(children: [
                              Flexible(
                                child: FutureBuilder(
                                  future: widget.viewModel
                                      .checkStockSalesFromApi(
                                          widget.salesmanData['ID_GUDANG']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else {
                                      return Column(children: [
                                        Expanded(
                                            child: ListView.builder(
                                          itemCount:
                                              widget.viewModel.stocks.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final stocks =
                                                widget.viewModel.stocks[index];

                                            if (sendData.length <= index) {
                                              sendData.add([
                                                stocks.id,
                                                stocks.nama,
                                                stocks.saldo
                                              ]); // Changed to add an int for barang.id
                                            }
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 8.0),
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 16.0),
                                                    title: Text(
                                                        '${stocks.id} - ${stocks.nama}'),
                                                    trailing: Text(
                                                        'Stok: ${stocks.saldo.toStringAsFixed(0)} ${stocks.namaSatuan}'),
                                                    onTap: () {
                                                      // Tambahkan logika untuk menavigasi ke halaman detail barang di sini
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (dateController.text !=
                                                    'Pilih Tanggal' &&
                                                selectedValue != null) {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Barang yang akan dikembalikan :'),
                                                    content: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              'Gudang Tujuan $selectedGudangNama'),
                                                          SizedBox(height: 10),
                                                          Container(
                                                            width: double
                                                                .maxFinite,
                                                            height: 300,
                                                            child: ListView
                                                                .builder(
                                                              itemCount:
                                                                  sendData
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final item =
                                                                    sendData[
                                                                        index];
                                                                return ListTile(
                                                                  title: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('Barang ID: ${item[0]}'),
                                                                            Text('Nama: ${item[1]}'),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                          'Jumlah: ${item[2]}'),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ]),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          var idGudangTujuan =
                                                              selectedValue!;
                                                          final response = await widget
                                                              .viewModel
                                                              .postPengembalianSales(
                                                                  dateController
                                                                      .text,
                                                                  widget.salesmanData[
                                                                      'ID_SALES'],
                                                                  widget.salesmanData[
                                                                      'ID_GUDANG'],
                                                                  idGudangTujuan,
                                                                  getPeriode(
                                                                      dateController
                                                                          .text),
                                                                  widget.salesmanData[
                                                                      'ID_DEPO'],
                                                                  sendData);
                                                          if (response.responseData[
                                                                  'success'] ==
                                                              true) {
                                                            print(
                                                                "response ${response.responseData['bukti']}");
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Bukti(
                                                                              mode: 'pengembalian',
                                                                              bukti: response.responseData['bukti'],
                                                                            )));
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                  'Gagal menyimpan data'),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                            ));
                                                          }
                                                        },
                                                        child: Text('Kirim'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          // Batal
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Batal'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              // Tampilkan pesan jika tanggal atau gudang belum dipilih
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Pilih tanggal dan gudang terlebih dahulu'),
                                                duration: Duration(seconds: 2),
                                              ));
                                            }
                                          },
                                          child: Text('Show Data'),
                                        ),
                                      ]);
                                    }
                                  },
                                ),
                              )
                            ]))
        ]));
  }
}
