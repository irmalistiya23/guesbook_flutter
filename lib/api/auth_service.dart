import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:guestbook_flutter/utils/constants.dart';

class AuthService {
  final String baseUrl = Constants.apiUrl;

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Simpan token ke shared prefs jika perlu
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return response.statusCode == 201;
  }

  // Add logout, refresh token, etc.
}
