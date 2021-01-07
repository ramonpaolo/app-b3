//---- Packages
import 'package:flutter/material.dart';

//---- Screens
import 'package:Ibovespa/src/views/home/Home.dart';
import 'package:Ibovespa/src/views/user/User.dart';

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
                Icons.monetization_on,
                color: Colors.white,
              ),
              label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.follow_the_signs,
              color: Colors.white,
            ),
            label: "Seguidas",
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
