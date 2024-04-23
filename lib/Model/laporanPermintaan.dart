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

  static List<TransaksiPermintaan> listFromJson(Map<String, dynamic> json) {
    List<TransaksiPermintaan> transaksis = [];
    json.forEach((key, value) {
      List<dynamic> transaksiList = value;
      transaksiList.forEach((transactionJson) {
        transaksis.add(TransaksiPermintaan(
          id: transactionJson['ID'],
          kodeTransaksi: transactionJson['KDTRN'],
          tanggal: transactionJson['TANGGAL'],
          bukti: transactionJson['BUKTI'],
          periode: transactionJson['PERIODE'],
          idSales: transactionJson['ID_SALESMAN'],
          idDepo: transactionJson['ID_DEPO'],
          idGudang: transactionJson['ID_GUDANG'],
          nomorPermintaan: transactionJson['NOPERMINTAAN'],
          idBarang: transactionJson['ID_BARANG'],
          nama: transactionJson['NAMASINGKAT'],
          jumlahItem: double.parse(transactionJson['QTY']),
        ));
      });
    });
    return transaksis;
  }
}
