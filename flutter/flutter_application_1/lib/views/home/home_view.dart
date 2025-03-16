import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/navigation_bar/navigation_bar.dart';

void main() {
  runApp(LinkShortenerApp());
}

class LinkShortenerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Link Shortener',
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
  String _selectedDomain = 'shortener.isharoverwhite.com';
  String? _shortenedUrl;

  void _shortenUrl() {
    setState(() {
      _shortenedUrl = '$_selectedDomain/${_aliasController.text.isNotEmpty ? _aliasController.text : "generated_code"}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(), // Add the navigation bar here
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adjust container size to be smaller
            double containerWidth = constraints.maxWidth * 0.4;
            double containerHeight = constraints.maxHeight * 0.3;

            if (constraints.maxWidth < 800) {
              containerWidth = constraints.maxWidth * 0.6;
              containerHeight = constraints.maxHeight * 0.3;
            }

            return Center(
              child: Container(
                width: containerWidth,
                height: containerHeight,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: SingleChildScrollView(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Text('Shorten a long URL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter long link here',
                      labelText: 'Shorten a long URL', // Added label text
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: _selectedDomain),
                              readOnly: true, // Make it uneditable
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _aliasController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter alias',
                                labelText: 'Enter alias',
                                filled: true,
                                fillColor: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _shortenUrl,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 135, 0, 139), foregroundColor: Colors.white),
                          child: Text('Shorten URL', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(height: 40),
                      if (_shortenedUrl != null)
                        Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              children: [
                                Text('Success!', style: TextStyle(color: const Color.fromARGB(255, 133, 2, 185), fontWeight: FontWeight.bold)),
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
          },
        ),
      ),
    );
  }
}
