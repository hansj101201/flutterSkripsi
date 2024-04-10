import 'dart:convert';
import 'package:http/http.dart' as http;

class PengembalianViewModel {
  // Future<bool> postPengembalianSales(String tanggal, String idSales, String idGudang, String idGudangTujuan, String periode, String idDepo, List<List<dynamic>> data) async {
  //   final url = Uri.parse('http://10.0.2.2:8000/api/pengembalian/postPengembalian'); // Ganti dengan URL API pengembalian sales Anda
  //   final response = await http.post(
  //     url,
  //     body: jsonEncode({
  //       'TANGGAL': tanggal,
  //       'ID_SALES': idSales,
  //       'ID_GUDANG': idGudang,
  //       'ID_DEPO': idDepo,
  //       'PERIODE' : periode,
  //       'ID_GUDANG_TUJUAN': idGudangTujuan,
  //       'DATA' : data,
  //     }),
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final responseData = jsonDecode(response.body);
  //     print(responseData);
  //     print('Pengembalian Sales berhasil dipost');
  //     return true;
  //   } else {
  //     final responseData = jsonDecode(response.body);
  //     print(responseData);
  //     print('Gagal melakukan pengembalian sales');
  //     return false;
  //   }
  // }
}
