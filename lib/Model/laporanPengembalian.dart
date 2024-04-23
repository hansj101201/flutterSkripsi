class TransaksiPengembalian {
  final String id;
  final String kodeTransaksi;
  final String tanggal;
  final String bukti;
  final String periode;
  final String idDepo;
  final String idGudang;
  final String idBarang;
  final String nama;
  final double jumlahItem;
  final String gudangNama;

  TransaksiPengembalian({
    required this.id,
    required this.kodeTransaksi,
    required this.tanggal,
    required this.bukti,
    required this.periode,
    required this.idDepo,
    required this.idGudang,
    required this.idBarang,
    required this.nama,
    required this.jumlahItem,
    required this.gudangNama,
  });

  static List<TransaksiPengembalian> listFromJson(Map<String, dynamic> json) {
    List<TransaksiPengembalian> transaksis = [];
    json.forEach((key, value) {
      List<dynamic> transaksiList = value;
      transaksiList.forEach((transactionJson) {
        transaksis.add(TransaksiPengembalian(
          id: transactionJson['ID'],
          kodeTransaksi: transactionJson['KDTRN'],
          tanggal: transactionJson['TANGGAL'],
          bukti: transactionJson['BUKTI'],
          periode: transactionJson['PERIODE'],
          idDepo: transactionJson['ID_DEPO'],
          idGudang: transactionJson['ID_GUDANG'],
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
