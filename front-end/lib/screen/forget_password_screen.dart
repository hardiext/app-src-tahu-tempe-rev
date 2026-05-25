import 'package:flutter/material.dart';
import 'package:warungly/core/auth/auth_service.dart';
import 'package:warungly/screen/verify_otp_screen.dart';
// Pastikan impor halaman VerifyOtpScreen Anda di sini jika berbeda file
// import 'package:warungly/screens/verify_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final authService = AuthService();
  bool loading = false;

  Future<void> sendOtp() async {
    if (emailController.text.trim().isEmpty) {
      return;
    }

    setState(() => loading = true);

    try {
      final res = await authService.sendOtp(
        emailController.text.trim(),
      );

      if (!mounted) return;

      // Sesuaikan kondisi ini dengan struktur response dari dio/backend Anda
      if (res['message'] == 'OTP sent' || res['status'] == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyOtpScreen(
              email: emailController.text.trim(),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res['error'] ?? res['message'] ?? 'Failed to send OTP',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: loading ? null : sendOtp,
                child: loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
