import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_application_1/widgets/navigation_bar/navigation_bar.dart';
import 'package:flutter_application_1/services/urlservices.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _urlController = TextEditingController();
  final UrlService _urlService = UrlService();

  String? _shortenedUrl;
  List<UrlData> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final links = await _urlService.getAllLinks();
      setState(() {
        _history = links.reversed.toList();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load history");
    }
  }

  Future<void> _shortenUrl() async {
    final originalUrl = _urlController.text.trim();
    if (originalUrl.isEmpty) return;

    final shortUrl = await _urlService.shortenUrl(originalUrl);
    if (shortUrl != null) {
      setState(() {
        _shortenedUrl = shortUrl;
      });
      _showResultDialog(shortUrl);
      _loadHistory();
    } else {
      Fluttertoast.showToast(msg: "Failed to shorten URL");
    }
  }

  Future<void> _deleteLink(String shortCode) async {
    try {
      await _urlService.deleteUrlByShortCode(shortCode);
      Fluttertoast.showToast(msg: "Deleted successfully!");
      _loadHistory();
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to delete URL");
    }
  }

  void _showResultDialog(String shortUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Shortened Link"),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 300,
              maxWidth: 300,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SelectableText(shortUrl, style: TextStyle(color: Colors.blue)),
                  SizedBox(height: 10),
                  Container(
                    height: 150,
                    width: 150,
                    child: QrImageView(
                      data: shortUrl,
                      version: QrVersions.auto,
                      size: 150,
                    ),
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
            ),
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
        child: Center(
          child: Container(
            width: 500,
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
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  SizedBox(height: 30),
                  if (_history.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shortened Links History",
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh, color: Colors.white),
                          onPressed: _loadHistory,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 300,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          final link = _history[index];
                          return Card(
                            color: Color.fromARGB(255, 50, 50, 50),
                            child: ListTile(
                              title: SelectableText(
                                link.originalUrl,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: SelectableText(
                                link.shortUrl,
                                style: TextStyle(color: Colors.blue),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Shortened Link'),
                                      content: Text('Are you sure you want to delete this link?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text('Delete', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    final parts = link.shortUrl.split('/');
                                    final shortCode = parts.isNotEmpty ? parts.last : '';
                                    if (shortCode.isNotEmpty) {
                                      await _deleteLink(shortCode);
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
