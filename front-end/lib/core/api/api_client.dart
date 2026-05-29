import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = "http://192.168.18.15:8080/api";

  Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) {
    return http.post(
      Uri.parse("$baseUrl$path"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> get(
    String path, {
    String? token,
  }) {
    return http.get(
      Uri.parse("$baseUrl$path"),
      headers: {
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }
}