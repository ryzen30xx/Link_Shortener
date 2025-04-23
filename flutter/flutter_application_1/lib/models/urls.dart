class UrlRequest {
  final String originalUrl;

  UrlRequest({required this.originalUrl});

  Map<String, dynamic> toJson() {
    return {'originalUrl': originalUrl};
  }
}

class UrlResponse {
  final String shortUrl;

  UrlResponse({required this.shortUrl});

  factory UrlResponse.fromJson(Map<String, dynamic> json) {
    return UrlResponse(shortUrl: json['shortUrl']);
  }
}
