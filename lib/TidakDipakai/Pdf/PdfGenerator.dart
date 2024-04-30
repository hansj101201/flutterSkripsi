import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFInvoiceGenerator extends StatefulWidget {
  final viewModel;

  PDFInvoiceGenerator({required this.viewModel});

  @override
  _PDFInvoiceGeneratorState createState() => _PDFInvoiceGeneratorState();
}

class _PDFInvoiceGeneratorState extends State<PDFInvoiceGenerator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate PDF Invoice'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await widget.viewModel
                  .generateAndDownloadPdf('10-04-2024', '25-04-2024');
              openPdfFile(context);
            },
            child: Text('Generate Invoice'),
          ),
          ElevatedButton(
            onPressed: () async {
              await widget.viewModel
                  .sendEmail('10-04-2024', '25-04-2024');
            },
            child: Text('Send Email'),
          ),
        ],
      )),
    );
  }

  void openPdfFile(BuildContext context) async {
    // Ganti path dengan path file PDF yang diunduh
    String filePath = '/storage/emulated/0/Documents/test1.pdf';

    // Tampilkan file PDF menggunakan PDFView
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Pdf',
              style: TextStyle(fontSize: 30),
            ),
            centerTitle: true,
            toolbarHeight: 100,
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
}
