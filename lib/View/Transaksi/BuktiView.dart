import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/CustomBackButton/DisabledBackButton.dart';
import 'package:flutter_skripsi/ViewModel/ViewModel.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';

class Bukti extends StatefulWidget {
  final String mode;
  final String bukti;
  final ViewModel viewModel;

  Bukti({required this.mode, required this.bukti, required this.viewModel});

  @override
  State<Bukti> createState() => _BuktiState();
}

class _BuktiState extends State<Bukti> {
  @override
  void initState() {
    super.initState();
  }

  bool tampilanSkor = true;

  @override
  Widget build(BuildContext context) {
    String appBarTitle = '';

    if (widget.mode == 'permintaan') {
      appBarTitle = 'Permintaan';
    } else if (widget.mode == 'penjualan') {
      appBarTitle = 'Penjualan';
    } else if (widget.mode == 'pengembalian') {
      appBarTitle = 'Pengembalian';
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(appBarTitle),
        ),
        body: CustomWillPopScope(
          child: Column(children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Data sudah disimpan dengan Nomor Bukti : ',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${widget.bukti}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (widget.mode == 'penjualan')
                      ElevatedButton.icon(
                        onPressed: () async {
                          String currentYear = DateTime.now().year.toString();
                          await widget.viewModel
                              .generatePdf(widget.bukti, currentYear);
                          openPdfFile(context);
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Atur tingkat kebulatan di sini
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          // Ubah warna latar belakang di sini
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 20.0)), // Atur padding di sini
                        ),
                        icon: Icon(Icons.download),
                        label: Text(
                          'Download Invoice',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    SizedBox(height: 10),
                    if (widget.mode == 'penjualan')
                      ElevatedButton(
                        onPressed: () async {
                          String currentYear = DateTime.now().year.toString();
                          bool success = await widget.viewModel
                              .sendEmail(widget.bukti, currentYear);
                          if (success) {
                            Fluttertoast.showToast(
                              msg: "Email successfully sent",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Atur tingkat kebulatan di sini
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          // Ubah warna latar belakang di sini
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 20.0)), // Atur padding di sini
                        ),
                        child: Text(
                          'Send Email',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Atur tingkat kebulatan di sini
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        // Ubah warna latar belakang di sini
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0)), // Atur padding di sini
                      ),
                      child: const Text(
                        'Home',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
        ));
  }

  void openPdfFile(BuildContext context) async {
    // Ganti path dengan path file PDF yang diunduh
    String currentYear = DateTime.now().year.toString();
    String filePath =
        '/storage/emulated/0/Documents/${widget.bukti}-$currentYear.pdf';

    // Tampilkan file PDF menggunakan PDFView
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('PDF File'),
            actions: [
              IconButton(
                icon: Icon(Icons.mail),
                onPressed: () async {
                  String currentYear = DateTime.now().year.toString();
                  bool success = await widget.viewModel
                      .sendEmail(widget.bukti, currentYear);
                  if (success) {
                    Fluttertoast.showToast(
                      msg: "Email successfully sent",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  _shareFile(context, filePath);
                },
              ),
            ],
          ),
          body: Center(
            child: PDFView(
              filePath: filePath,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
            ),
          ),
        ),
      ),
    );
  }

  void _shareFile(BuildContext context, String filePath) {
    Share.shareFiles([filePath],
        subject: 'Sharing File', text: 'Check out this file!');
  }
}
