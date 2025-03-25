import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/home/home_view.dart';
import 'package:flutter_application_1/views/login/register_view.dart';
import 'package:flutter_application_1/views/panel/ManageURLView.dart';

void main() {
  runApp(const MyApp());
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
      onGenerateRoute: (settings) {
        if (settings.name == null || settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => ManageURLsView(),
          );
        }

        Uri uri = Uri.parse(settings.name!);
        if (uri.pathSegments.isNotEmpty) {
          String shortUrl = uri.pathSegments.first;
          print('shortUrl: $shortUrl');
          // You can handle the shortUrl logic here if needed, or remove this block entirely.
        }

        return MaterialPageRoute(
          builder: (context) => RegisterView(),
        );
      },
      initialRoute: '/',
    );
  }
}
