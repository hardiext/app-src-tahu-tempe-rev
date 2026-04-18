class Pesanan {
  int pesananId;
  DateTime tanggal;
  String status;
  int totalHarga;


  Pesanan({
    required this.pesananId,
    DateTime? tanggal,
    this.status = "Dibuat",
    this.totalHarga = 0,
  }) : tanggal = tanggal ?? DateTime.now();


  void buatPesanan() {
    status = "Diproses";
    print("Pesanan ID $pesananId telah dibuat pada $tanggal.");
  }


  void updateStatus(String statusBaru) {
    status = statusBaru;
    print("Status pesanan ID $pesananId diperbarui menjadi: $status");
  }


  void setTotalHarga(int total) {
    totalHarga = total;
  }


  void tampilkanPesanan() {
    print("ID Pesanan   : $pesananId");
    print("Tanggal      : $tanggal");
    print("Status       : $status");
    print("Total Harga  : Rp$totalHarga");
  }
}