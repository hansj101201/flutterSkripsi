class TransaksiCustomer {
  final double totalNetto;
  final double totalDiscount;
  final String idCustomer;
  final String nama;
  final double totalJumlah;

  TransaksiCustomer({
    required this.totalNetto,
    required this.totalDiscount,
    required this.idCustomer,
    required this.nama,
    required this.totalJumlah,
  });

  factory TransaksiCustomer.fromJson(Map<String, dynamic> json) {
    return TransaksiCustomer(
      totalNetto: double.parse(json['total_netto']),
      totalDiscount: double.parse(json['total_diskon']),
      idCustomer: json['ID_CUSTOMER'],
      nama: json['NAMA'],
      totalJumlah: double.parse(json['total_jumlah']),
    );
  }
}
