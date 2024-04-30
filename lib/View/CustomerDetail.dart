import 'package:flutter/material.dart';
import 'package:flutter_skripsi/Model/Customer.dart';

class CustomerDetail extends StatelessWidget {
  final Customer customer;

  CustomerDetail({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Customer',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${customer.idCustomer} - ${customer.nama}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Alamat: ${customer.alamat}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Kota: ${customer.kota}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Kode Pos: ${customer.kodepos}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Telepon: ${customer.telepon}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'PIC: ${customer.pic}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'No HP: ${customer.nomorHp}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 30),
            Text(
              'Alamat Kirim: ${customer.alamatKirim}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Kota Kirim: ${customer.kotaKirim}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Kode Pos Kirim: ${customer.kodeposKirim}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Telepon Kirim: ${customer.teleponKirim}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'PIC Kirim: ${customer.picKirim}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'No HP Kirim: ${customer.nomorHpKirim}',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
