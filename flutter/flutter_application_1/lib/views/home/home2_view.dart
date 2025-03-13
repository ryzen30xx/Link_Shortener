import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/navigation_bar/navigation_bar.dart';
import 'package:flutter_application_1/views/login/login_view.dart';



void main() {
  runApp(LinkShortenerApp());
}

class LinkShortenerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();
  String _selectedDomain = 'tinyurl.com';
  String? _shortenedUrl;

  void _shortenUrl() {
    setState(() {
      _shortenedUrl = '$_selectedDomain/${_aliasController.text.isNotEmpty ? _aliasController.text : "generated_code"}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Link Shortener - The Original URL Shortener', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage())),
                  child: Text('Login'),
                ),
                SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: Text('About')),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Shorten a long URL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter long link here',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDomain,
                      decoration: InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                      items: ['tinyurl.com', 'short.ly', 'myurl.io'].map((domain) => DropdownMenuItem(value: domain, child: Text(domain))).toList(),
                      onChanged: (value) => setState(() => _selectedDomain = value!),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _aliasController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter alias',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _shortenUrl,
                child: Text('Shorten URL'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              ),
              SizedBox(height: 20),
              if (_shortenedUrl != null)
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Success!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        SelectableText(_shortenedUrl!, style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}