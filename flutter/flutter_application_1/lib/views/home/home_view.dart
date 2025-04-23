import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/navigation_bar/navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:flutter_application_1/services/urlservices.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();
  final UrlService _urlService = UrlService();

  String _selectedDomain = 'localhost';
  String? _shortenedUrl;

  Future<void> _shortenUrl() async {
    final originalUrl = _urlController.text.trim();
    if (originalUrl.isEmpty) return;

    final shortUrl = await _urlService.shortenUrl(originalUrl);

    if (shortUrl != null) {
      setState(() {
        _shortenedUrl = shortUrl;
      });
      _showResultDialog(shortUrl);
    } else {
      Fluttertoast.showToast(msg: "Failed to shorten URL");
    }
  }

  void _showResultDialog(String shortUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Shortened Link"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(shortUrl, style: TextStyle(color: Colors.blue)),
              SizedBox(height: 10),
              QrImageView(
                data: shortUrl,
                version: QrVersions.auto,
                size: 150,
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: shortUrl));
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "Copied to clipboard");
                },
                icon: Icon(Icons.copy),
                label: Text("Copy"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double containerWidth = constraints.maxWidth * 0.15;
            if (constraints.maxWidth < 900) {
              containerWidth = constraints.maxWidth * 0.5;
            }
            if (constraints.maxWidth < 600) {
              containerWidth = constraints.maxWidth * 0.8;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: containerWidth,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 33, 33, 33),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: 5,
                            offset: Offset(7, 7),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            TextField(
                              controller: _urlController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter URL",
                                hintStyle: TextStyle(color: Colors.white),
                                labelText: "Link",
                                labelStyle: TextStyle(color: Color.fromARGB(255, 167, 167, 167)),
                                filled: true,
                                fillColor: Color.fromARGB(255, 40, 40, 40),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: TextEditingController(text: _selectedDomain),
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 40, 40, 40),
                                    ),
                                    style: TextStyle(color: Color.fromARGB(255, 111, 108, 108)),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _aliasController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter alias',
                                      hintStyle: TextStyle(color: Colors.white),
                                      labelText: 'Alias',
                                      labelStyle: TextStyle(color: Color.fromARGB(255, 167, 167, 167)),
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 40, 40, 40),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _shortenUrl,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 16, 32, 255),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  'Shorten URL',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    flex: 6,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Shorten your links instantly",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
