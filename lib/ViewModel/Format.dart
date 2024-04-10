String getPeriode(String tanggal) {
  var parts = tanggal.split('-');
  var day = int.parse(parts[0]); // Konversi string menjadi integer untuk hari
  var month = int.parse(parts[1]); // Konversi string menjadi integer untuk bulan
  var year = int.parse(parts[2]); // Konversi string menjadi integer untuk tahun

  // Buat objek DateTime menggunakan tahun, bulan (dikurangi 1 karena bulan dimulai dari 0), dan hari
  var date = DateTime(year, month, day);

  // Ambil tahun dan bulan dari objek DateTime
  var yyyy = date.year;
  var mm = date.month;

  // Format tahun dan bulan menjadi format yyyymm
  var yyyymm = yyyy.toString() + (mm < 10 ? '0' : '') + mm.toString();

  return yyyymm;
}

String formatHarga(int harga) {
  // Menggunakan metode toLocaleString untuk mengonversi angka menjadi format dengan pemisah ribuan
  return harga.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match match) => '${match[1]},',
  );
}