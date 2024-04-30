import 'package:flutter/material.dart';
import 'package:flutter_skripsi/Model/Gudang.dart';
import 'package:flutter_skripsi/View/Transaksi/BuktiView.dart';
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Icon bawaan tombol kembali
            iconSize: 40, // Atur ukuran ikon tombol kembali di sini
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Pengembalian',
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
          toolbarHeight: 100,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 9.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: Colors.white, // Mengatur warna ikon menjadi putih
                ),
                iconSize: 40,
                onPressed: () {
                  var periode = getPeriode(dateController.text);
                  print(periode);

                  if (selectedValue == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Pilih customer terlebih dahulu'),
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Mengatur sudut yang dibulat
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Barang yang akan dikembalikan:',
                                style: TextStyle(fontSize: 30),
                              ),
                              SizedBox(height: 8),
                              // Menambahkan sedikit ruang di antara judul dan subtitle
                              Text(
                                'Gudang Tujuan : $selectedValue - $selectedGudangNama',
                                style: TextStyle(fontSize: 30),
                              ),
                            ],
                          ),
                          content: SizedBox(
                            width: double.maxFinite,
                            height: 300,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(),
                              child: SingleChildScrollView(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Flexible(
                                        child: Container(
                                          width: double.maxFinite,
                                          height: 300,
                                          child: ListView.builder(
                                            itemCount: sendData.length,
                                            itemBuilder: (context, index) {
                                              final item = sendData[index];
                                              return ListTile(
                                                  title: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          '${item[0]} - ${item[1]}',
                                                          style: TextStyle(
                                                              fontSize: 25),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${formatHarga((item[2].toInt()))} ${item[3]}",
                                                        style: TextStyle(
                                                            fontSize: 25),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  )
                                                ],
                                              ));
                                            },
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  var idGudangTujuan = selectedValue!;
                                  final response = await widget.viewModel
                                      .postPengembalianSales(
                                          dateController.text,
                                          widget.salesmanData['ID_SALES'],
                                          widget.salesmanData['ID_GUDANG'],
                                          idGudangTujuan,
                                          getPeriode(dateController.text),
                                          widget.salesmanData['ID_DEPO'],
                                          sendData);
                                  if (response.responseData['success'] ==
                                      true) {
                                    print(
                                        "response ${response.responseData['bukti']}");
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => Bukti(
                                                  mode: 'pengembalian',
                                                  bukti: response
                                                      .responseData['bukti'],
                                                  viewModel: widget.viewModel,
                                                )));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Gagal menyimpan data'),
                                      duration: Duration(seconds: 2),
                                    ));
                                  }
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Atur tingkat kebulatan di sini
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                  // Ubah warna latar belakang di sini
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal:
                                              20.0)), // Atur padding di sini
                                ),
                                child: Text(
                                  'Proses',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Batal
                                  Navigator.of(context).pop();
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Atur tingkat kebulatan di sini
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  // Ubah warna latar belakang di sini
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal:
                                              20.0)), // Atur padding di sini
                                ),
                                child: Text(
                                  'Kembali',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                color: Colors.black,
              ),
            )
          ],
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 300,
            height: 80,
            child: GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 16),
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
                                'Tidak dapat input pengembalian karena sudah closing',
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
                                                stocks.saldo,
                                                stocks.namaSatuan
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
                                        )),
                                      ]);
                                    }
                                  },
                                ),
                              )
                            ]))
        ]));
  }
}
