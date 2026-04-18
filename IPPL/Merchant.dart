class Merchant extends User {
  String namaToko;

  Merchant({
    required int userId,
    required String nama,
    required String email,
    required String password,
    required this.namaToko,
    String role = "Merchant",
  }) : super(
          userId: userId,
          nama: nama,
          email: email,
          password: password,
          role: role,
        );


  void tambahMakanan(String namaMakanan, int harga) {
    print("$namaToko menambahkan makanan: $namaMakanan (Rp$harga)");
  }


  void lihatPesanan(List<Pesanan> daftarPesanan) {
    print("Daftar Pesanan di $namaToko:");
    for (var pesanan in daftarPesanan) {
      pesanan.tampilkanPesanan();
      print("------");
    }
  }

 
  void updateStatusPesanan(Pesanan pesanan, String statusBaru) {
    pesanan.updateStatus(statusBaru);
    print("$namaToko mengupdate status pesanan.");
  }


  void tampilkanMerchant() {
    print("Nama Merchant : $nama");
    print("Nama Toko     : $namaToko");
    print("Email         : $email");
  }
}