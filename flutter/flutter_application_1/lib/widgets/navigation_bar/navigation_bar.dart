import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        children: <Widget>[
          SizedBox(width: 60,
          height: 180,
          child: Image.asset('../../../web/icons/Icon-192.png'),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _NavBarItem("Shorten Link"),
              SizedBox(width: 60),
              _NavBarItem('About'),
              SizedBox(width: 60),
              _NavBarItem('Login'),
              SizedBox(width: 60),
            ],
          )
        ],
      ),
    );
  }

}

class _NavBarItem extends StatelessWidget {
  final String title;
  const _NavBarItem(this.title);
  

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontSize: 18),);
  }
}