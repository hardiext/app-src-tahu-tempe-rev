import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import '../api/api_client.dart';

class AuthService {
  final api = ApiClient();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// REGISTER
  Future register(
    String email,
    String password,
    String username,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user!;

    await user.sendEmailVerification();

    final token = await user.getIdToken();

    final res = await api.post(
      "/public/register",
      {
        "id_token": token,
        "name": username,
        "role": "buyer",
      },
    );

    if (res.statusCode != 200) {
      throw Exception(res.body);
    }

    return {
      "message": "Verification email sent",
    };
  }

  /// LOGIN
  Future login(
    String email,
    String password,
  ) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await cred.user!.reload();

    final user = FirebaseAuth.instance.currentUser!;

    if (!user.emailVerified) {
      await _auth.signOut();

      throw Exception("Email belum diverifikasi");
    }

    final token = await user.getIdToken();

    final res = await api.post(
      "/public/login",
      {
        "id_token": token,
      },
    );

    if (res.statusCode != 200) {
      throw Exception(res.body);
    }

    return jsonDecode(res.body);
  }

  /// GOOGLE LOGIN
  Future<Map<String, dynamic>> loginGoogle(
    String idToken,
  ) async {
    final res = await api.post(
      "/public/login-google",
      {},
      token: idToken,
    );

    return jsonDecode(res.body);
  }

  /// SEND OTP
  Future<Map<String, dynamic>> sendOtp(
    String email,
  ) async {
    final res = await api.post(
      "/forgot-password/send-otp",
      {
        "email": email,
      },
    );

    return jsonDecode(res.body);
  }

  /// VERIFY OTP
  Future<Map<String, dynamic>> verifyOtp(
    String email,
    String otp,
  ) async {
    final res = await api.post(
      "/forgot-password/verify-otp",
      {
        "email": email,
        "otp": otp,
      },
    );

    return jsonDecode(res.body);
  }

  /// RESET PASSWORD
  Future<Map<String, dynamic>> resetPassword(
    String email,
    String password,
  ) async {
    final res = await api.post(
      "/forgot-password/reset",
      {
        "email": email,
        "new_password": password,
      },
    );

    return jsonDecode(res.body);
  }

  /// LOGOUT
  Future logout() async {
    await _auth.signOut();
  }
}