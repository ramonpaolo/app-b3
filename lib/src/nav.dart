//---- Packages
import 'package:flutter/material.dart';

//---- Screens
import 'package:Ibovespa/src/views/home/home.page.dart';
import 'package:Ibovespa/src/views/user/user.page.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page == 0 ? Home() : User(),
      backgroundColor: Colors.grey[900],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: Text(
                "Home",
                style: TextStyle(color: Colors.white),
              )),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            title: Text(
              "User",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
        selectedItemColor: Colors.white,
        selectedFontSize: 16,
        currentIndex: _page,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
