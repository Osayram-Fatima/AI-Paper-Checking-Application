import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ── Change this to your PC's local IP when testing on a real phone ──
  // e.g. 'http://192.168.1.5:3000'
  // On emulator use: 'http://10.0.2.2:3000'
  static const String baseUrl = 'http://10.0.2.2:3000';

  // ── POST /api/auth/signup ──
  static Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String cnic,
    required String gender,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/signup');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'cnic': cnic,
        'gender': gender,
        'role': role,
      }),
    );

    final data = jsonDecode(response.body);
    data['statusCode'] = response.statusCode;
    return data;
  }

  // ── POST /api/auth/signin ──
  static Future<Map<String, dynamic>> signin({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/signin');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    data['statusCode'] = response.statusCode;
    return data;
  }
}
