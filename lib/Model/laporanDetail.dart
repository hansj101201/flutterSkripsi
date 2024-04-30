class TransaksiDetail {
  final String tanggal;
  final String bukti;
  final String idCustomer;
  final double jumlah;
  final double netto;
  final double qty;
  final String idBarang;
  final String namaSingkat;
  final String nama;
  final double jumlahBarang;
  final double discount;

  TransaksiDetail({
    required this.tanggal,
    required this.bukti,
    required this.idCustomer,
    required this.jumlah,
    required this.netto,
    required this.qty,
    required this.idBarang,
    required this.namaSingkat,
    required this.nama,
    required this.jumlahBarang,
    required this.discount,
  });

  factory TransaksiDetail.fromJson(Map<String, dynamic> json) {
    return TransaksiDetail(
      tanggal: json['TANGGAL'],
      bukti: json['BUKTI'],
      idCustomer: json['ID_CUSTOMER'],
      jumlah: double.parse(json['JUMLAH']),
      netto: double.parse(json['NETTO']),
      qty: double.parse(json['QTY']),
      idBarang: json['ID_BARANG'],
      namaSingkat: json['NAMASINGKAT'],
      nama: json['NAMA'],
      jumlahBarang: double.parse(json['totalbarang']),
      discount: double.parse(json['DISCOUNT']),
    );
  }
}
