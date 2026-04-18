class Pembayaran {
  int pembayaranId;
  String metode;
  String status;
  DateTime tanggalBayar;


  Pembayaran({
    required this.pembayaranId,
    required this.metode,
    this.status = "Belum Dibayar",
    DateTime? tanggalBayar,
  }) : tanggalBayar = tanggalBayar ?? DateTime.now();


  void prosesPembayaran() {
    if (status == "Belum Dibayar") {
      status = "Diproses";
      print("Pembayaran ID $pembayaranId sedang diproses dengan metode $metode.");
    } else {
      print("Pembayaran sudah diproses sebelumnya.");
    }
  }


  void konfirmasiPembayaran() {
    if (status == "Diproses") {
      status = "Lunas";
      tanggalBayar = DateTime.now();
      print("Pembayaran ID $pembayaranId berhasil dikonfirmasi.");
    } else {
      print("Pembayaran belum diproses.");
    }
  }


  void tampilkanPembayaran() {
    print("ID Pembayaran : $pembayaranId");
    print("Metode        : $metode");
    print("Status        : $status");
    print("Tanggal Bayar : $tanggalBayar");
  }
}