import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:warungly/core/auth/auth_service.dart';
import 'package:warungly/screen/reset_password_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final authService = AuthService();
  final otpController = TextEditingController(); 
  bool loading = false;

  Future<void> verifyOtp() async {
    // Validasi diubah menjadi 6 digit
    if (otpController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan masukkan 6 digit kode OTP')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final res = await authService.verifyOtp(
        widget.email,
        otpController.text.trim(),
      );

      if (!mounted) return;

      if (res['message'] == 'OTP verified' || res['status'] == 'success') { 
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(email: widget.email),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['error'] ?? res['message'] ?? 'OTP invalid'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- KONFIGURASI STYLE UNTUK KOTAK OTP (PINPUT) ---
    final defaultPinTheme = PinTheme(
      width: 50, // Diperkecil dari 56 ke 50 agar muat 6 kotak di layar
      height: 56,
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // Abu-abu terang
        borderRadius: BorderRadius.circular(8), // Mengubah bulat (28) menjadi kotak ber-radius (8)
        border: Border.all(color: Colors.transparent),
      ),
    );

    // Tema opsional ketika kotak sedang diklik/fokus oleh user
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: Colors.black, width: 1.5), // Efek border hitam saat aktif
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Tombol Back Bulat di kiri atas
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 2. Judul Screen
              const Text(
                'Enter OTP Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              // 3. Deskripsi Teks
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Check your SMS! We\'ve sent a one-time verification code to +99 923 123 124. Enter the code below to verify your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 4. Input OTP (Pinput 6 Digit & Desain Kotak Ber-radius)
              Pinput(
                length: 6, // Diubah menjadi 6 digit
                controller: otpController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                separatorBuilder: (index) => const SizedBox(width: 8), // Jarak antar kotak disesuaikan
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      width: 2,
                      height: 16,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 5. Tombol Continue / Verify
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: loading ? null : verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Background Hitam
                    foregroundColor: Colors.white, // Warna Teks Putih
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27), // Melengkung oval
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // 6. Teks Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t get OTP? ',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Taruh logika kirim ulang OTP disini jika ada
                    },
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
