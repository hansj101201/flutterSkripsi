import 'package:flutter/material.dart';
import 'package:flutter_skripsi/Model/Gudang.dart';
import 'package:flutter_skripsi/ViewModel/BarangViewModel.dart';
import 'package:flutter_skripsi/ViewModel/GudangViewModel.dart';
import 'package:flutter_skripsi/ViewModel/Format.dart';
import 'package:flutter_skripsi/ViewModel/PengembalianViewModel.dart';
import 'package:flutter_skripsi/ViewModel/ViewModel.dart';

class PengembalianCanvasView extends StatefulWidget {
  final ViewModel viewModel;
  // final GudangViewModel gudangViewModel;
  final Map<String, dynamic> salesmanData;

  PengembalianCanvasView(
      {required this.viewModel,
      // required this.gudangViewModel,
      required this.salesmanData});

  @override
  _PengembalianCanvasViewState createState() => _PengembalianCanvasViewState();
}

class _PengembalianCanvasViewState extends State<PengembalianCanvasView> {
  late TextEditingController dateController;
  late TextEditingController gudangController;
  late PengembalianViewModel pengembalianViewModel;
  List<List<dynamic>> sendData = [];
  DateTime? _selectedDate;
  String? selectedValue;
  String? selectedGudangNama;

  @override
  void initState() {
    super.initState();
    // pengembalianViewModel = PengembalianViewModel();
    dateController = TextEditingController(text: 'Pilih Tanggal');
    gudangController = TextEditingController(text: 'Pilih Gudang Tujuan');
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
      _selectedDate = picked;
      if (_selectedDate == null) {
        dateController.text = 'Pilih Tanggal';
      } else {
        dateController.text =
            '${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year}';
      }
      print('Date selected: $_selectedDate');
      // Tambahkan logika untuk menggunakan tanggal yang dipilih
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stok Kanvas'),
      ),
      body: FutureBuilder(
        future: widget.viewModel
            .checkStockSalesFromApi(widget.salesmanData['ID_GUDANG']),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: TextField(
                  readOnly: true,
                  controller: gudangController,
                  style: TextStyle(fontSize: 30),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon:
                        Icon(Icons.arrow_drop_down), // Atur padding konten
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
                                future: widget.viewModel.getListGudang(
                                    widget.salesmanData['ID_DEPO']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
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
                                        selectedValue = newValue ??
                                            ''; // Update selectedValue
                                        // Close the dialog after selection
                                        Navigator.pop(context);
                                        updateSelectedGudang(gudangs
                                            .firstWhere(
                                              (gudang) => gudang.idGudang.toString() == selectedValue,
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
                  child: ListView.builder(
                itemCount: widget.viewModel.stocks.length,
                itemBuilder: (BuildContext context, int index) {
                  final stocks = widget.viewModel.stocks[index];

                  if (sendData.length <= index) {
                    sendData.add([
                      stocks.id,
                      stocks.nama,
                      stocks.saldo
                    ]); // Changed to add an int for barang.id
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          title: Text('${stocks.id} - ${stocks.nama}'),
                          trailing:
                              Text('Stok: ${stocks.saldo.toStringAsFixed(0)} ${stocks.namaSatuan}'),
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
                  if (dateController.text != 'Pilih Tanggal' &&
                      selectedValue != null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Barang yang akan dikembalikan :'),
                          content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Gudang Tujuan $selectedGudangNama'),
                                SizedBox(height: 10),
                                Container(
                                  width: double.maxFinite,
                                  height: 300,
                                  child: ListView.builder(
                                    itemCount: sendData.length,
                                    itemBuilder: (context, index) {
                                      final item = sendData[index];
                                      return ListTile(
                                        title: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Barang ID: ${item[0]}'),
                                                  Text('Nama: ${item[1]}'),
                                                ],
                                              ),
                                            ),
                                            Text('Jumlah: ${item[2]}'),
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
                                var idGudangTujuan = selectedValue!;
                                final success = await widget.viewModel
                                    .postPengembalianSales(
                                        dateController.text,
                                        widget.salesmanData['ID_SALES'],
                                        widget.salesmanData['ID_GUDANG'],
                                        idGudangTujuan,
                                        getPeriode(dateController.text),
                                        widget.salesmanData['ID_DEPO'],
                                        sendData);
                                if (success) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
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
                  } else {
                    // Tampilkan pesan jika tanggal atau gudang belum dipilih
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Pilih tanggal dan gudang terlebih dahulu'),
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
    );
  }
}
