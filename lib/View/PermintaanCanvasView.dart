import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_skripsi/ViewModel/BarangViewModel.dart';
import 'package:flutter_skripsi/ViewModel/Format.dart';
import 'package:flutter_skripsi/ViewModel/PermintaanViewModel.dart';
import 'package:flutter_skripsi/ViewModel/ViewModel.dart';

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
  late PermintaanViewModel permintaanViewModel;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    permintaanViewModel = PermintaanViewModel();
    data = [];
    controllers = [];
    dateController = TextEditingController(text: 'Pilih Tanggal');
    print('Salesman Data: ${widget.salesmanData}');
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
      if (_selectedDate == null){
        dateController.text = 'Pilih Tanggal';
      } else {
        dateController.text = '${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year}';
      }
      print('Date selected: $_selectedDate');
      // Tambahkan logika untuk menggunakan tanggal yang dipilih
    }
  }

  @override
  Widget build(BuildContext context) {
    // Example usage
    return Scaffold(
      appBar: AppBar(
        title: Text('Permintaan Kanvas'),
      ),
      body: FutureBuilder(
        future: widget.viewModel.fetchBarangsFromApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                SizedBox(height: 20,),
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
                    itemCount: widget.viewModel.barangs.length,
                    itemBuilder: (context, index) {
                      final barang = widget.viewModel.barangs[index];
                      // Add a new list to the data list for each barang
                      if (data.length <= index) {
                        data.add([barang.id,barang.nama, 0]); // Changed to add an int for barang.id
                        controllers.add(TextEditingController(text: '0'));
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              title: Text(barang.nama),
                              subtitle: Text('ID: ${barang.id} - Satuan: ${barang.namaSatuan}'),
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
                                      final value = data[index][2];
                                      if (value > 0) {
                                        data[index][2] = value - 1;
                                        controllers[index].text = (value - 1).toString();
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
                                          '-',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Container(
                                    width: 30,
                                    child: TextFormField(
                                      controller: controllers[index],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly // Hanya mengizinkan input angka
                                      ],
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        final intValue = int.tryParse(value) ?? 0;
                                        data[index][2] = intValue;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  GestureDetector(
                                    onTap: () {
                                      final value = data[index][2];
                                      data[index][2] = value + 1;
                                      controllers[index].text = (value + 1).toString();
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
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    var periode = getPeriode(dateController.text);
                    print(periode);
                    sendData = [];
                    // Tampilkan data yang akan dikirim
                    for (var item in data) {
                      if (item[2] != 0) {
                        if (!sendData.any((element) => element[0] == item[0])) {
                          sendData.add([item[0], item[1], item[2]]);
                        }
                      }
                    }
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
                                  title: Text('Barang ID: ${item[0]}, nama: ${item[1]}, value: ${item[2]}'),
                                );
                              },
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () async {
                                final success = await widget.viewModel.postPermintaanSales(
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
            );
          }
        },
      ),
    );
  }
}
