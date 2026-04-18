class User {
  int userId;
  String nama;
  String email;
  String password;
  String role;
  bool isLogin;


  User({
    required this.userId,
    required this.nama,
    required this.email,
    required this.password,
    required this.role,
    this.isLogin = false,
  });

  void register() {
    print("User $nama berhasil terdaftar dengan email $email.");
  }


  void login(String inputEmail, String inputPassword) {
    if (email == inputEmail && password == inputPassword) {
      isLogin = true;
      print("Login berhasil! Selamat datang, $nama.");
    } else {
      print("Email atau password salah.");
    }
  }


  void logout() {
    if (isLogin) {
      isLogin = false;
      print("$nama berhasil logout.");
    } else {
      print("User belum login.");
    }
  }


  void tampilkanUser() {
    print("ID User : $userId");
    print("Nama    : $nama");
    print("Email   : $email");
    print("Role    : $role");
    print("Status  : ${isLogin ? "Login" : "Logout"}");
  }
}