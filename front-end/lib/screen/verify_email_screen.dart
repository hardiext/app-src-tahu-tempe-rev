import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Pastikan path benar

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool loading = false;

  // --- Logic Tetap Sama ---
  Future checkVerification() async {
    setState(() => loading = true);
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser != null && refreshedUser.emailVerified) {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email berhasil diverifikasi")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Email belum diverifikasi")));
    }
    if (mounted) setState(() => loading = false);
  }

  Future resendEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email verifikasi dikirim ulang")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengirim email: $e")));
    }
  }

  // --- UI Baru yang Menarik ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FA,
      ), // Konsisten dengan Login & Register
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Visual: Ikon Email
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF42B983).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 80,
                  color: Color(0xFF42B983),
                ),
              ),
              const SizedBox(height: 40),

              // Judul
              const Text(
                "Verify Your Email",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Deskripsi
              const Text(
                "Kami telah mengirimkan link verifikasi ke email kamu. Silakan klik link tersebut untuk melanjutkan.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 40),

              // Tombol Utama (Check)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: loading ? null : checkVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF42B983),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Saya Sudah Verifikasi",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Tombol Kirim Ulang
              TextButton(
                onPressed: resendEmail,
                child: const Text(
                  "Kirim ulang email",
                  style: TextStyle(
                    color: Color(0xFF42B983),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Opsi Kembali ke Login jika salah email
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Gunakan email lain",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
