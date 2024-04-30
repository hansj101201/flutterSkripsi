class TransaksiPenerimaan {
  final String id;
  final String kodeTransaksi;
  final String tanggal;
  final String bukti;
  final String periode;
  final String idDepo;
  final String idGudang;
  final String nomorPermintaan;
  final String idBarang;
  final String nama;
  final double jumlahItem;
  final String gudangNama;

  TransaksiPenerimaan({
    required this.id,
    required this.kodeTransaksi,
    required this.tanggal,
    required this.bukti,
    required this.periode,
    required this.idDepo,
    required this.idGudang,
    required this.nomorPermintaan,
    required this.idBarang,
    required this.nama,
    required this.jumlahItem,
    required this.gudangNama,
  });

  factory TransaksiPenerimaan.fromJson(Map<String, dynamic> json) {
    return TransaksiPenerimaan(
      id: json['ID'],
      kodeTransaksi: json['KDTRN'],
      tanggal: json['TANGGAL'],
      bukti: json['BUKTI'],
      periode: json['PERIODE'],
      idDepo: json['ID_DEPO'],
      idGudang: json['ID_GUDANG'],
      nomorPermintaan: json['NOPERMINTAAN'],
      idBarang: json['ID_BARANG'],
      nama: json['NAMASINGKAT'],
      jumlahItem: double.parse(json['QTY']),
      gudangNama: json['NAMA'],
    );
  }
}
