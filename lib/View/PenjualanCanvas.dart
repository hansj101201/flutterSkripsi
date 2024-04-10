import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_skripsi/Model/Customer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_skripsi/ViewModel/Format.dart';
import 'package:flutter_skripsi/ViewModel/PengembalianViewModel.dart';
import 'package:flutter_skripsi/ViewModel/ViewModel.dart';

class PenjualanView extends StatefulWidget {
  final ViewModel viewModel;
  final Map<String, dynamic> salesmanData;

  PenjualanView({required this.viewModel, required this.salesmanData});

  @override
  _PenjualanViewState createState() => _PenjualanViewState();
}

class _PenjualanViewState extends State<PenjualanView> {
  List<List<dynamic>> data = [];
  List<List<dynamic>> sendData = [];
  late List<TextEditingController> controllers;
  late TextEditingController dateController;
  late TextEditingController gudangController;
  late PengembalianViewModel pengembalianViewModel;
  late TextEditingController subtotalController;
  late TextEditingController totalController;
  late TextEditingController nettoController;
  late TextEditingController potonganController;
  DateTime _selectedDate = DateTime.now();
  DateTime closingDate = DateTime.now(); // Variable to store the closing date
  String? selectedValue;
  String? selectedGudangNama;
  double previousPotongan = 0;

  @override
  void initState() {
    super.initState();
    data = [];
    controllers = [];
    pengembalianViewModel = PengembalianViewModel();
    dateController = TextEditingController();
    dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate);
    gudangController = TextEditingController(text: 'Pilih Customer');
    potonganController = TextEditingController(text: '0');
    subtotalController = TextEditingController();
    nettoController = TextEditingController();
    totalController = TextEditingController();
    potonganController.addListener(() {
      updatePotongan();
    });
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

  void updatePotongan() {
    double subtotal =
        double.tryParse(totalController.text.toString().replaceAll(",", "")) ??
            0;
    double potongan = double.tryParse(
            potonganController.text.toString().replaceAll(",", "")) ??
        0;

    // Memastikan potongan tidak melebihi subtotal
    if (potongan > subtotal) {
      Fluttertoast.showToast(
        msg: "Potongan tidak boleh melebihi Subtotal",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
      potonganController.text = formatHarga(previousPotongan.toInt());
    } else {
      double netto = subtotal - potongan;
      print("subtotal " + subtotal.toString());
      print("potongan " + potongan.toString());
      print("netto " + netto.toString());
      nettoController.text = formatHarga(netto.toInt());
      previousPotongan =
          potongan; // Simpan nilai potongan sebagai nilai sebelumnya
    }
  }

  void updateSubtotal() {
    double subtotal = calculateSubtotal();
    subtotalController.text = '${formatHarga(subtotal.toInt())}';
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

  double calculateSubtotal() {
    double subtotal = 0.0;
    for (int i = 0; i < data.length; i++) {
      double harga = data[i][2].toDouble();
      int jumlah = int.tryParse(controllers[i].text.replaceAll(",", "")) ?? 0;
      subtotal += harga * jumlah;
    }
    return subtotal;
  }

  @override
  Widget build(BuildContext context) {
    print("Closing Date" + closingDate.toString());

    final DateFormat formatter = DateFormat('dd-MM-yyyy');
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
          'Penjualan',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        toolbarHeight: 100,
        // Atur tinggi AppBar di sini
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 9.0),
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              iconSize: 40,
              onPressed: () {
                {
                  sendData = [];
                  for (var item in data) {
                    if (item[3] != 0) {
                      if (!sendData.any((element) => element[0] == item[0])) {
                        sendData
                            .add([item[0], item[1], item[2], item[3], item[4]]);
                      }
                    }
                  }
                  if (selectedValue == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Pilih customer terlebih dahulu'),
                      duration: Duration(seconds: 2),
                    ));
                  } else if (sendData.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Pilih barang terlebih dahulu'),
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    totalController.text = subtotalController.text;
                    nettoController.text = subtotalController.text;

                    var periode = getPeriode(dateController.text);

                    // Tampilkan data yang akan dikirim

                    print(dateController.text);
                    print(sendData);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Mengatur sudut yang dibulat
                          ),
                          title: Text(
                            'Customer : $selectedValue - $selectedGudangNama',
                            style: TextStyle(fontSize: 30),
                          ),
                          content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Expanded(
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
                                                Text(
                                                  '${item[1]}',
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${formatHarga((item[3]).toInt())} x ${(formatHarga(item[2].toInt()))}',
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                  ),
                                                ),
                                                Text(
                                                  "${formatHarga((item[4].toInt()))}",
                                                  style:
                                                      TextStyle(fontSize: 25),
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
                                Container(
                                  height: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    // Subtotal berada di sebelah kanan
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          // Atur margin di sini
                                          child: Text(
                                            "Subtotal:",
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Container(
                                              width: 300,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(),
                                                // Menambahkan border dengan garis solid
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                // Mengatur sudut border
                                                color: Colors.grey[
                                                    200], // Mengatur warna background
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  enabled: false,
                                                  controller: totalController,
                                                  // Buat subtotal tidak dapat diedit
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.black),
                                                  // Mengubah warna teks menjadi hitam
                                                  textAlign: TextAlign.right,
                                                  // Mengatur teks agar rata kanan
                                                  decoration: InputDecoration(
                                                    border: InputBorder
                                                        .none, // Menghilangkan garis bawah
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    // Subtotal berada di sebelah kanan
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          // Atur margin di sini
                                          child: Text(
                                            "Potongan:",
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Container(
                                            width: 300,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              // Menambahkan border dengan garis solid
                                              borderRadius: BorderRadius.circular(
                                                  10), // Mengatur sudut border
                                            ),
                                            child: TextField(
                                              controller: potonganController,
                                              keyboardType:
                                                  TextInputType.number,
                                              // Menampilkan keyboard numerik
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                // Hanya mengizinkan input angka
                                                TextInputFormatter.withFunction(
                                                    (oldValue, newValue) {
                                                  // Format angka saat nilainya berubah
                                                  final newString = formatHarga(
                                                      int.parse(newValue.text));
                                                  return TextEditingValue(
                                                    text: newString,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset: newString
                                                                .length),
                                                  );
                                                }),
                                              ],
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.black),
                                              // Mengubah warna teks menjadi hitam
                                              textAlign: TextAlign.right,
                                              // Mengatur teks agar rata kanan
                                              decoration: InputDecoration(
                                                border: InputBorder
                                                    .none, // Menghilangkan garis bawah
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    // Subtotal berada di sebelah kanan
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          // Atur margin di sini
                                          child: Text(
                                            "Netto:",
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Container(
                                            width: 300,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              // Menambahkan border dengan garis solid
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              // Mengatur sudut border
                                              color: Colors.grey[
                                                  200], // Mengatur warna background
                                            ),
                                            child: TextField(
                                              controller: nettoController,
                                              enabled: false,
                                              // Buat subtotal tidak dapat diedit
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.black),
                                              // Mengubah warna teks menjadi hitam
                                              textAlign: TextAlign.right,
                                              // Mengatur teks agar rata kanan
                                              decoration: InputDecoration(
                                                border: InputBorder
                                                    .none, // Menghilangkan garis bawah
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                          actions: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                    final success = await widget
                                        .viewModel
                                        .postPenjualan(
                                            dateController.text,
                                            widget.salesmanData[
                                                'ID_SALES'],
                                            widget.salesmanData[
                                                'ID_GUDANG'],
                                            selectedValue!,
                                            getPeriode(
                                                dateController.text),
                                            selectedGudangNama!,
                                            widget.salesmanData[
                                                'ID_DEPO'],
                                            totalController.text.replaceAll(
                                                ",", "").toString(),
                                            potonganController.text.replaceAll(
                                                ",", "").toString(),
                                            nettoController.text.replaceAll(
                                                ",", "").toString(),
                                            sendData);
                                    if (success) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Gagal menyimpan data'),
                                        duration: Duration(seconds: 2),
                                      ));
                                    }
                                },
                                child: Text('Proses'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Batal
                                  Navigator.of(context).pop();
                                },
                                child: Text('Kembali'),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                padding: EdgeInsets.only(left: 16), // Padding di sisi kiri
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
          // Your FutureBuilder Widget
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: TextField(
              readOnly: true,
              controller: gudangController,
              style: TextStyle(fontSize: 40),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.arrow_drop_down), // Atur padding konten
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text('Pilih Customer',
                            style: TextStyle(fontSize: 30)),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: FutureBuilder(
                            future: widget.viewModel
                                .getCustomer(widget.salesmanData['ID_SALES']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                List<Customer>? customers =
                                    widget.viewModel.customer;
                                if (customers == null) {
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
                                    updateSelectedGudang(customers
                                        .firstWhere(
                                          (customers) =>
                                              customers.idCustomer.toString() ==
                                              selectedValue,
                                        )
                                        ?.nama);
                                    print(selectedValue);
                                  },
                                  itemHeight: 140,
                                  items: customers.map((item) {
                                    print(item);
                                    return DropdownMenuItem<String>(
                                      value: item.idCustomer.toString(),
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        // Atur jarak vertikal di sini
                                        child: ListTile(
                                          title: Text(
                                            '${item.idCustomer} - ${item.nama}',
                                            style: TextStyle(fontSize: 30),
                                          ),
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
          SizedBox(
            height: 10,
          ),

          Expanded(
            child: dateController.text.isEmpty
                ? Center(child: Text('Masukkan Tanggal'))
                : FutureBuilder(
                    future: widget.viewModel.checkStockPenjualan(
                        widget.salesmanData['ID_GUDANG'], dateController.text),
                    builder: (context, snapshot) {
                      if (dateController.text == 'Pilih Tanggal') {
                        return Center(
                            child: Text('Masukkan Tanggal',
                                style: TextStyle(fontSize: 30)));
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (dateTime.isBefore(closingDate) ||
                          dateTime.isAtSameMomentAs(closingDate)) {
                        return Center(
                            child: Text(
                                'Tidak dapat input penjualan karena sudah closing',
                                style: TextStyle(fontSize: 40)));
                      } else {
                        return Column(children: [
                          Flexible(
                              child: ListView.builder(
                            itemCount: widget.viewModel.barangJualan.length,
                            itemBuilder: (BuildContext context, int index) {
                              final barang =
                                  widget.viewModel.barangJualan[index];

                              if (data.length <= index) {
                                data.add([
                                  barang.id,
                                  barang.nama,
                                  barang.harga,
                                  0,
                                  0,
                                  barang.saldo,
                                ]); // Changed to add an int for barang.id
                                controllers
                                    .add(TextEditingController(text: '0'));
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16.0),
                                      title: Text(
                                          '${barang.id} - ${barang.nama}',
                                          style: TextStyle(fontSize: 30)),
                                      subtitle: Text(
                                          'Stok : ${barang.saldo.toStringAsFixed(0)} ${barang.namaSatuan}',
                                          style: TextStyle(fontSize: 30)),
                                      trailing: Text(
                                          'Harga : ${formatHarga(barang.harga.toInt())}',
                                          style: TextStyle(fontSize: 30)),
                                      onTap: () {
                                        // Tambahkan logika untuk menavigasi ke halaman detail barang di sini
                                      },
                                    ),
                                    SizedBox(height: 10.0),
                                    Container(
                                      height:
                                          50, // Atur tinggi sesuai kebutuhan
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              final value =
                                                  data[index][3].toInt();
                                              if (value > 0) {
                                                data[index][3] = value - 1;
                                                controllers[index].text =
                                                    formatHarga((value - 1));
                                                data[index][4] =
                                                    data[index][3].toInt() *
                                                        data[index][2].toInt();
                                              }
                                              updateSubtotal();
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
                                            child: TextField(
                                              controller: controllers[index],
                                              textAlign: TextAlign.center,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                TextInputFormatter.withFunction(
                                                    (oldValue, newValue) {
                                                  // Format angka saat nilainya berubah
                                                  final newString = formatHarga(
                                                      int.parse(newValue.text));
                                                  return TextEditingValue(
                                                    text: newString,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset: newString
                                                                .length),
                                                  );
                                                }),
                                              ],
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.black,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              onChanged: (value) {
                                                final intValue = int.tryParse(
                                                        value.replaceAll(
                                                            ",", "")) ??
                                                    0;
                                                final maxValue = data[index][5]
                                                    .toInt(); // Ambil nilai maksimum dari data[index][5]
                                                if (intValue <= maxValue) {
                                                  // Periksa apakah nilai kurang dari atau sama dengan maksimum
                                                  data[index][3] = intValue;
                                                  data[index][4] = data[index]
                                                              [3]
                                                          .toInt() *
                                                      data[index][2].toInt();
                                                } else {
                                                  // Jika nilai melebihi maksimum, kembalikan ke nilai maksimum
                                                  data[index][3] = maxValue;
                                                  // Update teks pada TextField agar sesuai dengan nilai maksimum
                                                  controllers[index].text =
                                                      formatHarga(maxValue);
                                                }
                                                updateSubtotal();
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          GestureDetector(
                                            onTap: () {
                                              final value = data[index][3];
                                              final maxValue = data[index][5]
                                                  .toInt(); // Ambil nilai maksimum dari data[index][5]
                                              if (value < maxValue) {
                                                // Periksa apakah nilai lebih kecil dari maksimum
                                                data[index][3] = value + 1;
                                                data[index][4] =
                                                    data[index][3].toInt() *
                                                        data[index][2].toInt();
                                                controllers[index].text =
                                                    formatHarga((value + 1));
                                              }
                                              updateSubtotal();
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
                                                  '+',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 30.0,
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
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // Subtotal berada di sebelah kanan
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    // Atur margin di sini
                                    child: Text(
                                      "Subtotal:",
                                      style: TextStyle(fontSize: 50),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    // Atur margin di sini
                                    child: SizedBox(
                                      width: 400,
                                      height: 100,
                                      child: TextField(
                                        controller: subtotalController,
                                        enabled: false,
                                        // Buat subtotal tidak dapat diedit
                                        style: TextStyle(
                                            fontSize: 50, color: Colors.black),
                                        // Mengubah warna teks menjadi hitam
                                        textAlign: TextAlign.right,
                                        // Mengatur teks agar rata kanan
                                        decoration: InputDecoration(
                                          border: InputBorder
                                              .none, // Menghilangkan garis bawah
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ]);
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}