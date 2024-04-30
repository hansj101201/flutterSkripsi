import 'package:flutter/material.dart';
import 'package:flutter_skripsi/Model/laporanDetail.dart';
import 'package:flutter_skripsi/Model/laporanSummaryBarang.dart';
import 'package:flutter_skripsi/Model/laporanSummaryCustomer.dart';
import 'package:flutter_skripsi/ViewModel/ViewModel.dart';
import 'package:intl/intl.dart';

class LaporanPenjualan extends StatefulWidget {
  final ViewModel viewModel;
  final Map<String, dynamic> salesmanData;

  LaporanPenjualan({required this.viewModel, required this.salesmanData});

  @override
  _LaporanPenjualanState createState() => _LaporanPenjualanState();
}

class _LaporanPenjualanState extends State<LaporanPenjualan> {
  List<TransaksiDetail> data = [];
  List<TransaksiBarang> dataBarang = [];
  List<TransaksiCustomer> dataCustomer = [];
  late TextEditingController dateController;
  late TextEditingController dateController1;
  bool isDetailActive = true;
  late double totalDetail;
  late double totalDiscount;
  late double totalNetto;
  late double totalSummaryCust;
  late double totalDiscountCust;
  late double totalNettoCust;
  late double totalSummaryBarang;
  late double totalJumlah;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedDate1 = DateTime.now();
  bool isLoading = false; // Tambahkan variabel isLoading

  @override
  void initState() {
    super.initState();
    data = [];
    dataBarang = [];
    dataCustomer = [];
    dateController = TextEditingController();
    dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate);
    dateController1 = TextEditingController();
    dateController1.text = DateFormat('dd-MM-yyyy').format(_selectedDate1);
    totalDetail = 0;
    totalDiscount = 0;
    totalSummaryBarang = 0;
    totalSummaryCust = 0;
    totalNettoCust = 0;
    totalDiscountCust = 0;
    totalNetto = 0;
    totalJumlah = 0;
    print('Salesman Data: ${widget.salesmanData}');
    _fetchBarangs();
    calculateTotalDetail();
  }

  void calculateTotalDetail() {
    totalDetail = 0;
    totalDiscount = 0;
    totalSummaryCust = 0;
    totalDiscountCust = 0;
    totalNettoCust = 0;
    totalSummaryBarang = 0;
    Set<String> buktiSet = Set();
    for (int i = 0; i < data.length; i++) {
      totalDetail += data[i].jumlahBarang;
      if (!buktiSet.contains(data[i].bukti)) {
        totalDiscount += data[i].discount;
        buktiSet.add(data[i].bukti); // Tambahkan BUKTI ke dalam set
      }
    }
    totalNetto = totalDetail-totalDiscount;

    for (int i = 0; i < dataCustomer.length; i++) {
      totalSummaryCust += dataCustomer[i].totalJumlah;
      totalDiscountCust += dataCustomer[i].totalDiscount;
      totalNettoCust += dataCustomer[i].totalNetto;
    }

    for (int i = 0; i < dataBarang.length; i++) {
      totalSummaryBarang += dataBarang[i].totalJumlah;
    }
  }

  Future<void> _fetchBarangs() async {
    totalDetail = 0;
    DateTime startDate = DateTime.parse(_formatDate(dateController.text));
    DateTime endDate = DateTime.parse(_formatDate(dateController1.text));

    if (startDate.isAfter(endDate)) {
      // Jika ya, menampilkan pesan kesalahan dan menghentikan eksekusi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Tanggal awal tidak boleh lebih besar dari tanggal akhir.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Menghentikan eksekusi fungsi _fetchBarangs
    }
    setState(() {
      isLoading = true; // Set isLoading menjadi true saat memuat data
    });
    try {
      await widget.viewModel.getLaporanDetail(widget.salesmanData['ID_SALES'],
          dateController.text, dateController1.text);
      await widget.viewModel.getLaporanSummaryBarang(
          widget.salesmanData['ID_SALES'],
          dateController.text,
          dateController1.text);
      await widget.viewModel.getLaporanSummaryCustomer(
          widget.salesmanData['ID_SALES'],
          dateController.text,
          dateController1.text);
      setState(() {
        data = List.from(widget.viewModel.laporanDetail);
        dataBarang = List.from(widget.viewModel.laporanBarang);
        dataCustomer = List.from(widget.viewModel.laporanCustomer);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        data = [];
        dataBarang = [];
        dataCustomer = [];
        isLoading = false;
      });
    }
  }

  String _formatDate(String date) {
    List<String> parts = date.split('-');
    return '${parts[2]}-${parts[1]}-${parts[0]}';
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

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate1 = picked;
        if (_selectedDate1 == null) {
          dateController1.text = 'Pilih Tanggal';
        } else {
          dateController1.text =
              DateFormat('dd-MM-yyyy').format(_selectedDate1);
        }
        print('Date selected: $_selectedDate1');
      });
      _fetchBarangs();
    }
  }

  @override
  Widget build(BuildContext context) {
    calculateTotalDetail();
    Widget _buildCircularProgress() {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    Widget detailExpanded = Expanded(
        child: data.isEmpty || data == null
            ? Center(
                child: Text(
                  'Tidak ada penjualan di tanggal ini',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
              )
            : Column(children: [
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height *
                        0.7, // Misalnya, 80% dari tinggi layar
                  ),
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      print(data[index].bukti);
                      // Pastikan bahwa ListTile hanya dibuat untuk tanggal yang unik
                      if (index > 0 &&
                          data[index].tanggal == data[index - 1].tanggal) {
                        return SizedBox
                            .shrink(); // Skip creating ListTile for duplicate tanggal
                      }

                      // Buat variabel untuk menyimpan informasi transaksi dengan tanggal yang sama

                      String tanggalSekarang = data[index].tanggal;
                      String tanggalAwal = tanggalSekarang;
                      DateTime dateTime = DateTime.parse(tanggalAwal);
                      String tanggalBaru =
                          "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
                      List<TransaksiDetail> transaksisSama = [];

                      // Cari semua transaksi dengan tanggal yang sama
                      for (int i = index; i < data.length; i++) {
                        if (data[i].tanggal == tanggalSekarang) {
                          transaksisSama.add(data[i]);
                        } else {
                          break; // Jika tanggal berbeda, hentikan pencarian
                        }
                      }

                      // Ubah daftar transaksi yang sama menjadi tiga ListView
                      return Theme(
                        data: Theme.of(context).copyWith(
                          visualDensity: VisualDensity.compact,
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.only(top: 16, left: 16),
                          title: Text(
                            'Tanggal: $tanggalBaru',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: transaksisSama.length,
                            itemBuilder: (context, index) {
                              if (index > 0 &&
                                  data[index].bukti == data[index - 1].bukti) {
                                return SizedBox
                                    .shrink(); // Skip creating ListTile for duplicate tanggal
                              }

                              // Buat variabel untuk menyimpan informasi transaksi dengan tanggal yang sama
                              String buktiSekarang = data[index].bukti;
                              String namaCust = data[index].nama;
                              String total = NumberFormat.decimalPattern()
                                  .format(data[index].jumlah);
                              String discount = NumberFormat.decimalPattern()
                                  .format(data[index].discount);

                              List<TransaksiDetail> transaksisSama1 = [];

                              // Cari semua transaksi dengan tanggal yang sama
                              for (int i = index;
                                  i < transaksisSama.length;
                                  i++) {
                                if (data[i].bukti == buktiSekarang) {
                                  transaksisSama1.add(data[i]);
                                } else {
                                  break; // Jika tanggal berbeda, hentikan pencarian
                                }
                              }
                              return Theme(
                                  data: Theme.of(context).copyWith(
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.only(
                                        top: 16, left: 16, right: 16),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$buktiSekarang $namaCust',
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Diskon : $discount', // Teks discount
                                          style: TextStyle(
                                            fontSize: 30,
                                            // Atur ukuran teks sesuai kebutuhan
                                            fontWeight: FontWeight.normal,
                                            // Sesuaikan gaya teks
                                            color: Colors
                                                .red, // Sesuaikan warna teks
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                      '$total',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children:
                                          transaksisSama1.map((transaksi) {
                                        return ListTile(
                                          contentPadding: EdgeInsets.only(
                                              top: 0, left: 16, bottom: 0),
                                          horizontalTitleGap: 0,
                                          minVerticalPadding: 0,
                                          minLeadingWidth: 0,
                                          title: Row(
                                            children: [
                                              Expanded(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    '${transaksi.idBarang} - ${transaksi.namaSingkat}',
                                                    style: TextStyle(
                                                      fontSize: 30,
                                                      color: Color(0xFF120DF4),
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${NumberFormat.decimalPattern().format(transaksi.qty)}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    color: Color(0xFF120DF4),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${NumberFormat.decimalPattern().format(transaksi.jumlahBarang)}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    color: Color(0xFF120DF4),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      // Padding di sebelah kanan
                      child: Text(
                        'Total Penjualan',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      // Padding di sebelah kiri
                      child: Text(
                        '${NumberFormat.decimalPattern().format(totalDetail)}',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                // Padding di sebelah kanan
                child: Text(
                  'Total Discount',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                // Padding di sebelah kiri
                child: Text(
                  '${NumberFormat.decimalPattern().format(totalDiscount)}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                // Padding di sebelah kanan
                child: Text(
                  'Total Netto',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                // Padding di sebelah kiri
                child: Text(
                  '${NumberFormat.decimalPattern().format(totalNetto)}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          )
              ]));
    Widget summaryExpanded = Expanded(
        child: ((dataBarang.isEmpty || dataBarang == null) &&
                (dataCustomer.isEmpty || dataCustomer == null))
            ? Center(
                child: Text(
                  'Tidak ada penjualan di tanggal ini',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
              )
            : Column(children: [
                Text(
                  'By Customer',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dataCustomer.length,
                    itemBuilder: (context, index) {
                      // Implementasi item list untuk data customer di sini
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${dataCustomer[index].idCustomer}',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF120DF4),
                              ),
                            ),
                            SizedBox(width: 10), // Memberikan jarak antara teks
                            Text(
                              '${dataCustomer[index].nama}',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF120DF4),
                              ),
                            ),
                            SizedBox(width: 10), // Memberikan jarak antara teks
                            Text(
                                '${NumberFormat.decimalPattern().format(dataCustomer[index].totalJumlah)}',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF120DF4),
                                ),
                                textAlign: TextAlign.right),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                // Padding di sebelah kanan
                child: Text(
                  'Total Penjualan',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                // Padding di sebelah kiri
                child: Text(
                  '${NumberFormat.decimalPattern().format(totalSummaryCust)}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                // Padding di sebelah kanan
                child: Text(
                  'Total Discount',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                // Padding di sebelah kiri
                child: Text(
                  '${NumberFormat.decimalPattern().format(totalDiscountCust)}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                // Padding di sebelah kanan
                child: Text(
                  'Total Netto',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                // Padding di sebelah kiri
                child: Text(
                  '${NumberFormat.decimalPattern().format(totalNettoCust)}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
                Text(
                  'By Produk',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dataBarang.length,
                    itemBuilder: (context, index) {
                      // Implementasi item list untuk data barang di sini
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${dataBarang[index].idBarang} - ${dataBarang[index].namaSingkat}',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF120DF4),
                              ),
                            ),
                            SizedBox(width: 10), // Memberikan jarak antara teks
                            Text(
                                '${NumberFormat.decimalPattern().format(dataBarang[index].totalJumlah)}',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF120DF4),
                                ),
                                textAlign: TextAlign.right),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                // Padding di sebelah kanan
                child: Text(
                  'Total Penjualan',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                // Padding di sebelah kiri
                child: Text(
                  '${NumberFormat.decimalPattern().format(totalSummaryBarang)}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
              ]));
    Widget expandedWidget = isLoading
        ? _buildCircularProgress()
        : (isDetailActive ? detailExpanded : summaryExpanded);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Lihat Data Penjualan Barang',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              // Atur margin kiri dan kanan di sini
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Tgl : ',
                    style: TextStyle(
                        fontSize: 30, // Mengatur ukuran teks menjadi 30
                        color:
                            Colors.black // Mengatur warna teks menjadi 120DF4
                        ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
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
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    's/d : ',
                    style: TextStyle(
                        fontSize: 30, // Mengatur ukuran teks menjadi 30
                        color:
                            Colors.black // Mengatur warna teks menjadi 120DF4
                        ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _selectDate1(context);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          readOnly: true,
                          controller: dateController1,
                          style: TextStyle(fontSize: 30),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Tindakan ketika tombol "Detail" ditekan
                  // Misalnya, navigasi ke layar detail
                  setState(() {
                    isDetailActive = true; // Set tombol "Detail" aktif
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    isDetailActive
                        ? Colors.blue
                        : Colors
                            .grey, // Ubah warna sesuai dengan status aktif atau tidak
                  ),
                ),
                child: Text('Detail'),
              ),
              SizedBox(width: 20), // Memberikan jarak antara tombol
              ElevatedButton(
                onPressed: () {
                  // Tindakan ketika tombol "Summary" ditekan
                  // Misalnya, navigasi ke layar summary
                  setState(() {
                    isDetailActive = false; // Set tombol "Detail" tidak aktif
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    isDetailActive
                        ? Colors.grey
                        : Colors
                            .blue, // Ubah warna sesuai dengan status aktif atau tidak
                  ),
                ),
                child: Text('Summary'),
              ),
            ],
          ),
          expandedWidget,
        ],
      ),
    );
  }
}
