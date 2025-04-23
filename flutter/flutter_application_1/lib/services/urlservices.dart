import 'dart:convert';
import 'package:http/http.dart' as http;

class UrlService {
  final String _gatewayBaseUrl = 'http://localhost:5002';

  Future<String?> shortenUrl(String originalUrl) async {
    final url = Uri.parse('$_gatewayBaseUrl/api/link/shorten');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(originalUrl),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['shortUrl'];
    } else {
      print('Failed to shorten URL: ${response.body}');
      return null;
    }
  }
}
