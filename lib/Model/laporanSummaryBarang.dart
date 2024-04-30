class TransaksiBarang {
  final double totalQty;
  final String idBarang;
  final String namaSingkat;
  final double totalJumlah;

  TransaksiBarang({
    required this.totalQty,
    required this.idBarang,
    required this.namaSingkat,
    required this.totalJumlah,
  });

  factory TransaksiBarang.fromJson(Map<String, dynamic> json) {
    return TransaksiBarang(
      totalQty: double.parse(json['total_qty']),
      idBarang: json['ID_BARANG'],
      namaSingkat: json['NAMASINGKAT'],
      totalJumlah: double.parse(json['total_jumlah']),
    );
  }
}
