import 'package:flutter/material.dart';

class RedirectPage extends StatelessWidget {
  final String shortUrl;

  const RedirectPage({Key? key, required this.shortUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract the code from the short URL
    final code = shortUrl.split('/').last;

    // Fetch the original URL using the code
    Future<String> fetchOriginalUrl(String code) async {
      // Replace this with your actual logic to fetch the original URL
      // For example, you might make an HTTP request to your backend
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      return 'https://example.com/original-url'; // Replace with actual URL
    }

    // Redirect to the original URL
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final originalUrl = await fetchOriginalUrl(code);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewPage(url: originalUrl),
        ),
      );
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class RedirectView extends StatefulWidget {
  final String shortUrl;

  const RedirectView({Key? key, required this.shortUrl}) : super(key: key);

  @override
  _RedirectViewState createState() => _RedirectViewState();
}

class _RedirectViewState extends State<RedirectView> {
  @override
  void initState() {
    super.initState();

    // Extract the code from the short URL
    final code = widget.shortUrl.split('/').last;

    // Fetch the original URL using the code
    Future<String> fetchOriginalUrl(String code) async {
      // Replace this with your actual logic to fetch the original URL
      // For example, you might make an HTTP request to your backend
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      return 'https://example.com/original-url'; // Replace with actual URL
    }

    Future.delayed(Duration(seconds: 3), () async {
      final originalUrl = await fetchOriginalUrl(code);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewPage(url: originalUrl),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  const WebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement your WebView here
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView'),
      ),
      body: Center(
        child: Text('Loading $url'),
      ),
    );
  }
}