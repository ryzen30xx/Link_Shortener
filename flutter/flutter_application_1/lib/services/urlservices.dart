import 'dart:convert';
import 'package:http/http.dart' as http;

class UrlData {
  final int id;
  final String originalUrl;
  final String shortUrl;
  final String createdAt;

  UrlData({
    required this.id,
    required this.originalUrl,
    required this.shortUrl,
    required this.createdAt,
  });

  factory UrlData.fromJson(Map<String, dynamic> json) {
    return UrlData(
      id: json['id'],
      originalUrl: json['originalUrl'],
      shortUrl: json['shortUrl'],
      createdAt: json['createdAt'],
    );
  }
}

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
      return data['shortUrl'];
    } else {
      return null;
    }
  }

  Future<List<UrlData>> getAllLinks() async {
    final url = Uri.parse('http://localhost:5002/link/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => UrlData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load links');
    }
  }

  Future<void> deleteUrlByShortCode(String shortCode) async {
    final url = Uri.parse('http://localhost:5002/link/shortened/$shortCode');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete URL');
    }
  }
}
