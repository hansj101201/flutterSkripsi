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

  static List<TransaksiPenerimaan> listFromJson(Map<String, dynamic> json) {
    List<TransaksiPenerimaan> transaksis = [];
    json.forEach((key, value) {
      List<dynamic> transaksiList = value;
      transaksiList.forEach((transactionJson) {
        transaksis.add(TransaksiPenerimaan(
          id: transactionJson['ID'],
          kodeTransaksi: transactionJson['KDTRN'],
          tanggal: transactionJson['TANGGAL'],
          bukti: transactionJson['BUKTI'],
          periode: transactionJson['PERIODE'],
          idDepo: transactionJson['ID_DEPO'],
          idGudang: transactionJson['ID_GUDANG'],
          nomorPermintaan: transactionJson['NOPERMINTAAN'],
          idBarang: transactionJson['ID_BARANG'],
          nama: transactionJson['NAMASINGKAT'],
          jumlahItem: double.parse(transactionJson['QTY']),
          gudangNama: transactionJson['NAMA'],
        ));
      });
    });
    return transaksis;
  }
}
