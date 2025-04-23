import 'dart:convert';
import 'package:http/http.dart' as http;

class UrlService {
  Future<String?> shortenUrl(String originalUrl) async {
    final url = Uri.parse('http://localhost:5002/link/shorten');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'originalUrl': originalUrl}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['shortUrl']; // response trả về key là "shortUrl"
    } else {
      return null;
    }
  }
}
