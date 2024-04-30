class TransaksiPermintaan {
  final String id;
  final String kodeTransaksi;
  final String tanggal;
  final String bukti;
  final String periode;
  final String idSales;
  final String idDepo;
  final String idGudang;
  final String nomorPermintaan;
  final String idBarang;
  final String nama;
  final double jumlahItem;

  TransaksiPermintaan({
    required this.id,
    required this.kodeTransaksi,
    required this.tanggal,
    required this.bukti,
    required this.periode,
    required this.idSales,
    required this.idDepo,
    required this.idGudang,
    required this.nomorPermintaan,
    required this.idBarang,
    required this.nama,
    required this.jumlahItem,
  });

  factory TransaksiPermintaan.fromJson(Map<String, dynamic> json) {
    return TransaksiPermintaan(
      id: json['ID'],
      kodeTransaksi: json['KDTRN'],
      tanggal: json['TANGGAL'],
      bukti: json['BUKTI'],
      periode: json['PERIODE'],
      idSales: json['ID_SALESMAN'],
      idDepo: json['ID_DEPO'],
      idGudang: json['ID_GUDANG'],
      nomorPermintaan: json['NOPERMINTAAN'],
      idBarang: json['ID_BARANG'],
      nama: json['NAMASINGKAT'],
      jumlahItem: double.parse(json['QTY']),
    );
  }
}
