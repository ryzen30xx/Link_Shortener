import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/login/login_view.dart';

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              children: [
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}