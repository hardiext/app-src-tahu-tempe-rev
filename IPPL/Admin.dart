class Admin extends User {


  Admin({
    required int userId,
    required String nama,
    required String email,
    required String password,
    String role = "Admin",
  }) : super(
          userId: userId,
          nama: nama,
          email: email,
          password: password,
          role: role,
        );


  void verifikasiLaporan(Laporan laporan) {
    laporan.verifikasiLaporan();
    print("Admin $nama telah memverifikasi laporan.");
  }


  void lihatSemuaLaporan(List<Laporan> daftarLaporan) {
    print("Daftar Laporan:");
    for (var laporan in daftarLaporan) {
      laporan.tampilkanLaporan();
      print("------");
    }
  }


  void kelolaUser(User user) {
    print("Admin $nama sedang mengelola user: ${user.nama}");
  }
}