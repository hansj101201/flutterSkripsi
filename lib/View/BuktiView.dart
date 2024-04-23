import 'package:flutter/material.dart';
import 'package:flutter_skripsi/View/DisabledBackButton.dart';

class Bukti extends StatefulWidget {
  final String mode;
  final String bukti;

  Bukti({required this.mode, required this.bukti});

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
                    Text('Data sudah disimpan dengan Nomor Bukti : ',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      'Bukti : ${widget.bukti}',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,),
                    ),
                    SizedBox(height:10),
                    SizedBox(
                        width: 198,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            // Kembali ke halaman sebelumnya
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Home',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}
