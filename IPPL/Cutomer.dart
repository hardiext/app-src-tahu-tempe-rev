class Customer {
  String nama;
  String alamat;
  String noHp;


  Customer({
    required this.nama,
    required this.alamat,
    required this.noHp,
  });


  void lihatMakanan(List<String> daftarMakanan) {
    print("Daftar Makanan Tersedia:");
    for (var makanan in daftarMakanan) {
      print("- $makanan");
    }
  }


  void pesanMakanan(Pesanan pesanan) {
    pesanan.buatPesanan();
    print("$nama melakukan pemesanan.");
  }


  void beriReview(String isiReview, int rating) {
    print("$nama memberikan review:");
    print("Rating : $rating");
    print("Komentar : $isiReview");
  }


  void buatLaporan(Laporan laporan) {
    laporan.kirimLaporan();
    print("$nama membuat laporan dengan deskripsi: ${laporan.deskripsi}");
  }


  void tampilkanCustomer() {
    print("Nama   : $nama");
    print("Alamat : $alamat");
    print("No HP  : $noHp");
  }
}