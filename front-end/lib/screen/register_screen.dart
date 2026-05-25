import 'package:flutter/material.dart';
import 'package:warungly/screen/verify_email_screen.dart';
import '../core/auth/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();

  final auth = AuthService();
  bool loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> register() async {
    // Validasi: Pastikan semua field telah diisi oleh user
    if (usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi")),
      );
      return;
    }

    // Validasi: Memastikan password & konfirmasi password sama persis
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password dan Konfirmasi Password tidak cocok!")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await auth.register(
        emailController.text.trim(),
        passwordController.text.trim(),
        usernameController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Register success")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VerifyEmailPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    if (mounted) setState(() => loading = false);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Background light abu-abu terang sesuai UI Login
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Layout rata kiri konsisten
            children: [
              // Header Atas: Nama Aplikasi & Tombol Close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Join Workly",
                    style: TextStyle(
                      color: Color(0xFFFF570C), // Warna Oranye Brand
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Judul Halaman
              const Text(
                "Create your\nAccount",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 32),

              // Field Username
              const Text(
                "Username",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 8),
              _buildInputField(
                controller: usernameController,
                hint: "Judy Mobbin",
              ),
              const SizedBox(height: 20),

              // Field Email
              const Text(
                "Email address",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 8),
              _buildInputField(
                controller: emailController,
                hint: "Judy.mobbin@gmail.com",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Field Password
              const Text(
                "Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 8),
              _buildInputField(
                controller: passwordController,
                hint: "********",
                isPassword: true,
                obscureText: _obscurePassword,
                onToggleVisibility: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              const SizedBox(height: 20),

              // Field Confirm Password
              const Text(
                "Confirm Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 8),
              _buildInputField(
                controller: confirmPasswordController,
                hint: "********",
                isPassword: true,
                obscureText: _obscureConfirmPassword,
                onToggleVisibility: () {
                  setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                },
              ),
              const SizedBox(height: 32),

              // Tombol Utama Sign Up / Register
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: loading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF570C), // Warna Oranye
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28), // Berbentuk Kapsul Oval
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Bagian Bawah: Link Navigasi Kembali ke Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Color(0xFF666666), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Login here",
                      style: TextStyle(
                        color: Color(0xFFFF570C),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Component Input Field dengan Border Radius 12 & Gaya Minimalis
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Kotak bersudut lengkung halus halus
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFF666666),
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
        ),
      ),
    );
  }
}