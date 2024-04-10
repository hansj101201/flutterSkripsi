class BarangHargaStock {
  final String id;
  final double harga;
  final String maxMulaiBerlaku;
  final String nama;
  final String namaSatuan;
  final double saldo;

  BarangHargaStock({
    required this.id,
    required this.harga,
    required this.maxMulaiBerlaku,
    required this.nama,
    required this.namaSatuan,
    required this.saldo,
  });

  factory BarangHargaStock.fromJson(Map<String, dynamic> json) {
    return BarangHargaStock(
      id: json['ID_BARANG'],
      harga: double.parse(json['HARGA']),
      maxMulaiBerlaku: json['max_mulai_berlaku'],
      nama: json['NAMA'],
      namaSatuan: json['nama_satuan'],
      saldo: double.parse(json['saldo']),
    );
  }
}