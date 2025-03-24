import 'dart:convert';
import 'package:http/http.dart' as http;

class UrlService {
  static const String baseUrl = 'http://localhost:5254/api/URLs';

  // ✅ Fetch URLs from API
  static Future<List<Map<String, dynamic>>> fetchURLs() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception("Failed to load URLs");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  
}
