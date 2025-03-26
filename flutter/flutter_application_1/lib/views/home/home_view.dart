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
                  // 🔹 Khung nhập link (căn trái)
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
                                labelText: "Link",
                                filled: true,
                                fillColor: const Color.fromARGB(255, 40, 40, 40),
                                // Change here
                              ),
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
                                      fillColor: Colors.white,
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
                                      fillColor: Colors.white,
                                    ),
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
                                child: Text('Shorten URL', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            SizedBox(height: 30),
                            if (_shortenedUrl != null)
                              Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    children: [
                                      Text('Success!', style: TextStyle(color: Color.fromARGB(255, 133, 2, 185), fontWeight: FontWeight.bold)),
                                      SelectableText(_shortenedUrl!, style: TextStyle(color: Colors.blue)),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 50),

                  // 🔹 Slogan (căn phải)
                  Expanded(
                    flex: 6, // ✅ Chiếm 60% màn hình
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Shorten your links instantly",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 255, 255, 255),
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
