import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'http://localhost:5254/api/Users'; 

  // Updated to check both username and password
  static Future<Map<String, dynamic>?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login'); // Adjust API endpoint if needed

    try {

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}), // Now sending password
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return user data
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  static Future<String> register(String username, String email, String password) async {
    final url = Uri.parse(baseUrl); // POST to /api/Users

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userName': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return "success"; // ✅ Registration successful
      } else if (response.statusCode == 409) {
        return "exists"; // Username or Email already exists
      } else {
        return "error"; // Other errors
      }
    } catch (e) {
      return "error"; // API call failed
    }
  }
}
