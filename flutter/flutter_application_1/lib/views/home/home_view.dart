import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/navigation_bar/navigation_bar.dart';
import 'package:flutter_application_1/views/login/login_view.dart';
import 'dart:html' as html;

void main() {
  runApp(LinkShortenerApp());
}

class LinkShortenerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      theme: ThemeData.dark(),
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var children = [
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        },
        child: Text('Login'),
      ),
      SizedBox(width: 10),
      ElevatedButton(
        onPressed: () {},
        child: Text('About'),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Link Shortener - The Original URL Shortener',
          style: TextStyle(color: Colors.black),
        ),
        titleSpacing: 20,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: children,
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 39, 39, 39), // Set the background color to blue
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Shorten a long URL',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter long link here',
                ),
              ),
              SizedBox(height: 10),
              Opacity(
                opacity: 1,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Shorten URL'),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
