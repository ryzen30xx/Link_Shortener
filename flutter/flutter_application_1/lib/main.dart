// import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/home/home_view.dart';
// import 'package:flutter_application_1/views/login/login_view.dart';
// import 'package:flutter_application_1/';
// import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Link Shortener",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:HomeView()
    );
  }
}

