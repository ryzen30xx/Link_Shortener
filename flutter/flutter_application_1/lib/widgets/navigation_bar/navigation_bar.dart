import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/home/home_view.dart';
import 'package:flutter_application_1/views/login/login_view.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      title: Row(
        children: [
          Image.asset(
            'web/icons/Icon-192.png', // Replace with the path to your logo
            height: 30, // Adjust the height as needed
          ),
          SizedBox(width: 10), // Add some space between the logo and the title
          Text(
            'Link Shortener',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ],
      ),
      actions: [
        MouseRegion(
          onEnter: (_) {
            // Add your animation code here
          },
          onExit: (_) {
            // Add your animation code here
          },
          child: TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeView()),
              );
            },
            child: Text(
              'Home',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
        ),
        MouseRegion(
          onEnter: (_) {
            // Add your animation code here
          },
          onExit: (_) {
            // Add your animation code here
          },
          child: TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            },
            child: Text(
              'Sign In',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
        ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 161, 46, 255),
          borderRadius: BorderRadius.vertical( // Added borderRadius to the flexibleSpace container
            bottom: Radius.circular(0),
          ),
        ),
      ),
      backgroundColor: Colors.transparent, // Ensure the background color is transparent to show the gradient
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
