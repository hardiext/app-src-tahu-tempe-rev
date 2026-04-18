class Laporan {
  int laporanId;
  String deskripsi;
  String status;


  Laporan({
    required this.laporanId,
    required this.deskripsi,
    this.status = "Belum Diverifikasi",
  });


  void kirimLaporan() {
    print("Laporan dengan ID $laporanId berhasil dikirim.");
    status = "Terkirim";
  }


  void verifikasiLaporan() {
    if (status == "Terkirim") {
      status = "Diverifikasi";
      print("Laporan dengan ID $laporanId telah diverifikasi.");
    } else {
      print("Laporan belum dikirim, tidak bisa diverifikasi.");
    }
  }


  void tampilkanLaporan() {
    print("ID Laporan   : $laporanId");
    print("Deskripsi    : $deskripsi");
    print("Status       : $status");
  }
}