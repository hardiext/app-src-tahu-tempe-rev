import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleAuthService {

  Future<Map<String, dynamic>?> signInWithGoogle() async {

    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final idToken = await userCredential.user!.getIdToken();

    final res = await http.post(
      Uri.parse("http://10.0.2.2:8080/api/public/login-google"),
      headers: {
        "Authorization": "Bearer $idToken",
      },
    );

    final data = jsonDecode(res.body);

    return {
      "user": userCredential.user,
      "backend": data,
    };
  }
  
}
