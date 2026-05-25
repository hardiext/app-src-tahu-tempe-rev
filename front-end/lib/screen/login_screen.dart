import 'package:flutter/material.dart';
import 'package:warungly/core/auth/auth_service.dart';
import 'package:warungly/core/auth/google_service.dart';
import 'package:warungly/screen/forget_password_screen.dart';
import 'package:warungly/screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();
  bool loading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  // --- Logic Tetap Sama Sesuai Permintaan ---
  Future<void> login() async {
    setState(() => loading = true);
    try {
      final res = await auth.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login success")));
    } catch (e) {
      if (!mounted) return;
      String message = "Login gagal";
      if (e.toString().contains("user-not-found")) {
        message = "User tidak ditemukan";
      } else if (e.toString().contains("wrong-password")) {
        message = "Password salah";
      } else if (e.toString().contains("invalid-credential")) {
        message = "Email atau password salah";
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> loginGoogle() async {
    try {
      setState(() => loading = true);
      final service = GoogleAuthService();
      final result = await service.signInWithGoogle();
      if (result == null) {
        setState(() => loading = false);
        return;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Google login success")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Google login gagal: $e")));
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFFAFAFA,
      ), // Background abu-abu sangat terang menyerupai gambar
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Mengikuti gambar: rata kiri
            children: [
              // Bagian Header atas (Join Workly & Tombol Silang)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Join Workly",
                    style: TextStyle(
                      color: Color(0xFFFF570C), // Warna oranye sesuai gambar
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Judul Utama (Sign in to your Account)
              const Text(
                "Sign in to your\nAccount",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 32),

              // Label Email/Phone number
              const Text(
                "Email/Phone number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 8),

              // Input Email
              _buildInputField(
                controller: emailController,
                hint: "Judy.mobbin@gmail.com",
              ),
              const SizedBox(height: 20),

              // Label Password
              const Text(
                "Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 8),

              // Input Password
              _buildInputField(
                controller: passwordController,
                hint: "********",
                isPassword: true,
                obscureText: _obscurePassword,
                onToggleVisibility: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              const SizedBox(height: 16),

              // Remember me & Forget Password?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: const Color(0xFFFF570C),
                          onChanged: (val) =>
                              setState(() => _rememberMe = val!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Remember me",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // Taruh navigasi forgot password di sini jika diperlukan
                   
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ForgotPasswordScreen(),
                        ),
                      );
        
                    },
                    child: const Text(
                      "Forget Password ?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Tombol Utama (Continue)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: loading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFFF570C,
                    ), // Oranye sesuai gambar
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        28,
                      ), // Kapsul / Oval penuh
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Pembatas (or login with)
              Row(
                children: const [
                  Expanded(
                    child: Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "or login with",
                      style: TextStyle(color: Color(0xFF666666), fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tombol Sign in with Apple (Sesuai Gambar)
              _buildSocialButton(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Fitur Apple Login belum tersedia"),
                    ),
                  );
                },
                backgroundColor: Colors.black,
                textColor: Colors.white,
                borderColor: Colors.black,
                icon: const Icon(Icons.apple, color: Colors.white, size: 24),
                label: "Sign in with Apple",
              ),
              const SizedBox(height: 12),

              // Tombol Login Google (Menggantikan posisi 'Other sign up options')
              _buildSocialButton(
                onTap: loginGoogle,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                borderColor: const Color(0xFFE0E0E0),
                icon: Image.asset(
                  'assets/images/logo_google.png', // Pastikan path asset Anda benar
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback jika asset gambar google belum dimasukkan
                    return const Icon(
                      Icons.g_mobiledata,
                      color: Colors.red,
                      size: 24,
                    );
                  },
                ),
                label: "Sign in with Google",
              ),
              // Belum punya akun?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
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

  // Helper widget untuk membuat Input Field (Kotak Putih dengan Border Radius Sedikit)
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          12,
        ), // Kotak dengan radius sedikit sesuai gambar
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
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
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF666666),
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
        ),
      ),
    );
  }

  // Helper widget untuk membuat struktur tombol sosial media lebar di bawah
  Widget _buildSocialButton({
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
    required Widget icon,
    required String label,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              28,
            ), // Berbentuk oval / kapsul penuh
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
