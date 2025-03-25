import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/home/home_view.dart';
import 'package:flutter_application_1/views/login/login_view.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0, // ✅ Loại bỏ mặc định để tự thêm bóng đổ
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      title: Row(
        children: [
          Image.asset(
            'web/icons/Icon-192.png', // Thay đường dẫn thành logo của bạn
            height: 30,
          ),
          SizedBox(width: 10),
          Text(
            'Link Shortener',
            style: TextStyle(color: Color.fromARGB(255, 39, 39, 39)),
          ),
        ],
      ),
      actions: [
        _navButton(context, 'Home', HomeView()),
        _navButton(context, 'Sign In', LoginView()),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.white, //
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _navButton(BuildContext context, String title, Widget targetPage) {
    return MouseRegion(
      onEnter: (_) {
        // Bạn có thể thêm animation vào đây nếu cần
      },
      onExit: (_) {
        // Animation khi rời chuột khỏi nút
      },
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        },
        child: Text(
          title,
          style: TextStyle(
            color: Color.fromARGB(255, 39, 39, 39),
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
