import 'dart:convert';
import 'package:http/http.dart' as http;

class PermintaanViewModel {
  Future<bool> postPermintaanSales(String tanggal, String idSales, String idGudang, String periode, String idDepo, List<List<dynamic>> data) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/permintaan/postPermintaan'); // Ganti dengan URL API permintaan sales Anda
    final response = await http.post(
      url,
      body: jsonEncode({
        'TANGGAL': tanggal,
        'ID_SALES': idSales,
        'ID_GUDANG': idGudang,
        'ID_DEPO': idDepo,
        'PERIODE' : periode,
        'DATA' : data,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print(jsonEncode({
      'TANGGAL': tanggal,
      'ID_SALES': idSales,
      'ID_GUDANG': idGudang,
      'ID_DEPO': idDepo,
      'PERIODE' : periode,
      'DATA' : data,
    }));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      print('Permintaan Sales berhasil dipost');
      return true;
    } else {
      final responseData = jsonDecode(response.body);
      print(responseData);
      print('Gagal melakukan permintaan sales');
      return false;
    }
  }
}
